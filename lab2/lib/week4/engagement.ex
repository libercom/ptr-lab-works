defmodule Week4.Engagement do
  use GenServer

  alias Week4.EngagementUser

  def init(_args) do
    IO.puts "\e[32m[#{inspect(self())}] Engagement up\e[0m"

    {:ok, %{}}
  end

  def start_link(name) do
    GenServer.start_link(__MODULE__, nil, name: name)
  end

  def handle_info({:engagement_tweet, {hash, chunk}}, _users) do
    chunk = String.replace(chunk, "event: \"message\"\n\ndata: ", "")

    case Poison.decode(chunk, []) do
      {:ok, data} ->
        followers_count = data["message"]["tweet"]["user"]["followers_count"]
        favourites_count = data["message"]["tweet"]["user"]["favourites_count"]
        retweet_count = data["message"]["tweet"]["retweet_count"]
        user_name = data["message"]["tweet"]["user"]["screen_name"]

        followers_count = if followers_count == 0 do
          1
        else
          followers_count
        end

        engagement_ratio = (favourites_count + retweet_count) / followers_count

        # case Map.get(users, user_name) do
        #   nil ->
        #     {:noreply, Map.put(users, user_name, {engagement_ratio, 1})}
        #   {engagement_ratio_val, count} ->
        #     new_count = count + 1
        #     new_engagement_ratio = (engagement_ratio + engagement_ratio_val)

        #     users = Map.put(users, user_name, {new_engagement_ratio / new_count, new_count})

        #     IO.puts "\e[36m[#{inspect(self())}] [#{hash}] Engagement Ratio: #{user_name} -> #{new_engagement_ratio} \e[0m"

        #     {:noreply, users}
        # end
        send(:aggregator, {:handle_result, hash, :engagement_ratio, engagement_ratio})

        EngagementUser.calculate_engagement_per_user(user_name, hash, engagement_ratio)

        {:noreply, nil}

      {:error, _} ->
        IO.puts "\e[31m[#{inspect(self())}] Engagement calculator down\e[0m"

        Process.exit(self(), :kill)
    end
  end
end
