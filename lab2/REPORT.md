# FAF.PTR16.1 -- Project 1

> **Performed by:** Ignat Vasile, group FAF-202
> **Verified by:** asist. univ. Alexandru Osadcenco

## P1W1

I did all the tasks for the first checkpoint. Here goes the explanation:

I downloaded the docker image and created a container for the SSE streams.

I created two actors that are responsible for connecting to the SSE streams using the HTTPoison library and reading the data from the streams.

```erlang
def init(url) do
    {:ok, res} = HTTPoison.get(url, [], stream_to: self())

    {:ok, url}
end
```

The readers are responsible for redirecting the messages from the SSE stream to the printer actors.

```erlang
def handle_info(%HTTPoison.AsyncChunk{:chunk => chunk}, url) do
    send(:load_balancer, {:print_tweet, chunk})

    {:noreply, url}
end
```

The printer actor has been implemented to print messages after a random amount of time, which can be set during initialization.

```erlang
sleep_time = rem(:rand.uniform(1945), max_load_time - min_load_time) + min_load_time

Process.sleep(sleep_time)

chunk = String.replace(chunk, "event: \"message\"\n\ndata: ", "")

case Poison.decode(chunk, []) do
    {:ok, data} ->
    text = data["message"]["tweet"]["text"]

    case MessageStore.remove_message(hash) do
        :ok ->
        IO.puts "\e[36m[#{inspect(self())}] Tweet: #{text}\e[0m"
```

I have created an actor that performs analytics on SSE messages. This actor receives the SSE messages and conducts the analytics every 5 seconds.

```erlang
if map_size(hashtags) != 0 do
    {most_popular_hashtag, num_appeared} = Enum.max_by(hashtags, fn {_, v} -> v end)

    IO.puts "\e[35mMost popular hashtag: #{most_popular_hashtag}, which appeared #{num_appeared} times\e[0m"
end
```

## P1W2

I have completed all the tasks for the second week.

I created a worker by implementing a supervisor that starts the printers dynamically.

```erlang
children = Enum.map(1..3, fn x -> Supervisor.child_spec(
    {Printer, {String.to_atom("printer_#{x}"), load_values}},
    id: "printer_#{x}")
end)

Supervisor.init(children, strategy: :one_for_one, max_restarts: 10000)
```

For the mediator, I have created a load balancer that redirects messages to the least connected printer, which refers to the printer with the least amount of messages in its queue. The load balancer obtains information about the least connected printer from the Pool Supervisor.

```erlang
handler_actor_pids = Pool.get_least_connected()

Enum.each(handler_actor_pids, fn {x, count} ->
    IO.puts "\e[38;5;208m[Load Balancer] Sending request to: #{inspect(x)} with only #{count} messages in the mailbox\e[0m"

    send(x, {:print_tweet, chunk})
end)
```

I have added a use case to the printer actor where it will terminate itself upon receiving a "kill" message.

```erlang
{:error, _} ->
    IO.puts "\e[31m[#{inspect(self())}] Printer down\e[0m"

    Process.exit(self(), :kill)
```

## P1W3

I have completed all the tasks for the third week.

I have added the functionality to censor specific words in the printer actor.

```erlang
def censure_message(message, bad_words) do
    Enum.reduce(bad_words, message, fn bad_word, acc ->
      String.replace(acc, bad_word, String.duplicate("*", String.length(bad_word)))
    end)
end
```

I have created a new actor called "AutoScaling" that monitors the printers and checks the number of tasks they have to perform. Based on this information, it makes decisions to add or remove a printer dynamically.

```erlang
avg_message_count = Pool.get_avg_message_count() |> round()

if avg_message_count > expected_message_count do
    Pool.add_worker()
end

if avg_message_count < expected_message_count do
    Pool.remove_inactive_workers()
end

IO.inspect "[AutoScaling] Average message count: #{avg_message_count}"

process(sprint_length)
```

I have enhanced the Worker Pool to implement speculative execution of tasks. I created a message store that validates the messages that have already been processed and discards subsequent messages based on a hash comparison. Additionally, I have implemented the duplication of messages to multiple printer actors, with a default of 2 printer actors.

Here I store the message with the hash:

```erlang
hash = :crypto.hash(:sha256, chunk) |> Base.encode16()

state = Map.put(state, hash, chunk)

send(:load_balancer, {:print_tweet, {hash, chunk}})
```

Here I validate the message:

```erlang
if Map.get(state, hash) != nil do
    state = Map.delete(state, hash)

    {:reply, :ok, state}
else
    {:reply, :error, state}
end
```

## P1W4

I have completed all the tasks for the fourth week.

I have created two additional actors: one that calculates the sentiment score of a tweet and another that computes the engagement ratio. These actors receive a copy of the message from the load balancer, similar to the printer actor.

This is how I calculate engagement ratio.

```erlang
followers_count = data["message"]["tweet"]["user"]["followers_count"]
favourites_count = data["message"]["tweet"]["user"]["favourites_count"]
retweet_count = data["message"]["tweet"]["retweet_count"]
user_name = data["message"]["tweet"]["user"]["screen_name"]

engagement_ratio = (favourites_count + retweet_count) / followers_count
```

This is how I calculate the sentiment score.

```erlang
text = data["message"]["tweet"]["text"]
words = String.split(text, " ")
sentiment_score = Enum.reduce(words, 0, fn el, acc ->
    case Map.get(emotion_values, el) do
    nil ->
        acc
    val ->
        acc + val
    end
end)
```

I have created a generic worker pool that takes a module as an argument during initialization. This worker pool is responsible for creating and supervising actors of that specific module.

```erlang
def init({module, actor_name, num_of_workers}) do
    children = Enum.map(1..num_of_workers, fn x ->
      worker_name = String.to_atom("#{actor_name}_#{x}")

      Supervisor.child_spec({module, worker_name}, id: worker_name)
    end)

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 10000)
end
```

I have created three separate worker pools, and I start them in the application supervisor.

```erlang
GenericPool.start_link(:ps, Printer, "printer", 3)
GenericPool.start_link(:ss, Sentiment, "sentiment", 3)
GenericPool.start_link(:er, Engagement, "engagement", 3)
```

I have created an actor that stores users and their engagement ratios in a map, allowing for the calculation of the engagement ratio per user.

```erlang
case Map.get(users, user_name) do
    nil ->
        {:noreply, Map.put(users, user_name, {engagement_ratio, 1})}

    {engagement_ratio_val, count} ->
        new_count = count + 1
        new_engagement_ratio = (engagement_ratio + engagement_ratio_val)

        users = Map.put(users, user_name, {new_engagement_ratio / new_count, new_count})

        {:noreply, users}
end
```

## P1W5

I have completed all the tasks except for the last one.

I have created a new actor that collects the redacted tweets and prints them in batches. It maintains a queue to store the tweets, and once the queue reaches the maximum batch capacity, it will print all the tweets and empty the queue. Additionally, in case of a timeout, it will print all the tweets from the queue and empty it, regardless of whether it was full or not.

```erlang
 state = state ++ [result]

if length(state) >= batch_size do
    IO.puts "--------------------------------------------------------------"

    Enum.each(state, fn res ->
      Tuple.to_list(res) |> Enum.each(fn term -> IO.puts term end)
    end)

    {:noreply, {batch_size, time_interval, 0, []}}
else
    {:noreply, {batch_size, time_interval, timer, state}}
end
```

I have created a new actor that will collect all the results and aggregate them together based on a hash computed for each tweet. When it receives three results with the same hash, it will aggregate them together and send them to the batcher. The aggregation includes the sentiment score, engagement ratio, and redacted tweet.

```erlang
case Map.get(state, hash) do
    nil ->
    state = Map.put(state, hash, %{result_type => result})

    {:noreply, state}
    results ->
    results = Map.put(results, result_type, result)

    if map_size(results) == 5 do
        state = Map.delete(state, hash)

        send(:batcher, {:handle_result, results})

        {:noreply, state}
    else
        state = Map.put(state, hash, results)

        {:noreply, state}
    end
end
end
```

I have added the functionality to handle retweets in the printer actor. When the printer actor finds a retweet, it will send the retweet to the load balancer.

```erlang
retweet = data["message"]["tweet"]["retweeted_status"]

if retweet != nil do
    send(:load_balancer, {:print_tweet, Poison.encode!(%{"message" => %{"tweet" => retweet}})})
end
```

## P1W6

I have created an actor that serves as an in-memory database using the "ets" module. It contains two tables, one for users and one for tweets.

```erlang
def init(_init_args) do
    :ets.new(:users, [:set, :named_table])
    :ets.new(:tweets, [:set, :named_table])

    {:ok, nil}
end
```

I have modified the batcher actor to store the results in the database instead of simply storing them.

Here I send the results to the database actor:

```erlang
state = state ++ [result]

if length(state) >= batch_size do
    IO.puts "--------------------------------------------------------------"

    GenServer.cast(:db, {:add_batch, state})

    {:noreply, {batch_size, time_interval, 0, []}}
else
    {:noreply, {batch_size, time_interval, timer, state}}
end
```

Here I store them in the table:

```erlang
users = :ets.tab2list(:users)
tweets = :ets.tab2list(:tweets)

new_users = Enum.map(data, fn %{user_name: user_name, user_engagement_ratio: user_engagement_ratio} -> {user_name, user_engagement_ratio} end)

tweets = Enum.map(data, fn %{
    user_name: user_name,
    text: text,
    engagement_ratio: engagement_ratio,
    sentiment_score: sentiment_score
    } -> {text, user_name, engagement_ratio, sentiment_score} end)

:ets.insert(:users, new_users)
:ets.insert(:tweets, tweets)
```

## Conclusion

In conclusion, I learned a lot from this laboratory work, such as reading an SSE stream of data and processing the data from it. I applied the knowledge I gained from the previous laboratory work and the patterns we learned during the courses, such as Fan-Out, Fan-In, and others. It was very interesting to do.
