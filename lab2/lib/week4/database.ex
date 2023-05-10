defmodule Week4.Database do
  use GenServer

  def init(_init_args) do
    :ets.new(:users, [:set, :named_table])
    :ets.new(:tweets, [:set, :named_table])

    {:ok, nil}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: :db)
  end

  def handle_cast({:add_batch, data}, _state) do
    users = :ets.tab2list(:users)
    tweets = :ets.tab2list(:tweets)

    IO.inspect("Users in the database: #{length(users)}")
    IO.inspect("Tweets in the database: #{length(tweets)}")

    new_users = Enum.map(data, fn %{user_name: user_name, user_engagement_ratio: user_engagement_ratio} -> {user_name, user_engagement_ratio} end)

    tweets = Enum.map(data, fn %{
      user_name: user_name,
      text: text,
      engagement_ratio: engagement_ratio,
      sentiment_score: sentiment_score
      } -> {text, user_name, engagement_ratio, sentiment_score} end)

    :ets.insert(:users, new_users)
    :ets.insert(:tweets, tweets)

    {:noreply, nil}
  end
end
