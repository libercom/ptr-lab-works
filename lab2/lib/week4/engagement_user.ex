defmodule Week4.EngagementUser do
  use GenServer

  def init(args) do
    {:ok, args}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: :eru)
  end

  def handle_cast({:engagement_per_user, user_name, hash, engagement_ratio}, users) do
    case Map.get(users, user_name) do
      nil ->
        # IO.puts "\e[36m[#{inspect(self())}] [#{hash}] Engagement Ratio: #{user_name} -> #{engagement_ratio} \e[0m"

        send(:aggregator, {:handle_result, hash, :user_engagement_ratio, engagement_ratio})
        send(:aggregator, {:handle_result, hash, :user_name, user_name})

        {:noreply, Map.put(users, user_name, {engagement_ratio, 1})}
      {engagement_ratio_val, count} ->
        new_count = count + 1
        new_engagement_ratio = (engagement_ratio + engagement_ratio_val)

        users = Map.put(users, user_name, {new_engagement_ratio / new_count, new_count})

        send(:aggregator, {:handle_result, hash, :user_engagement_ratio, new_engagement_ratio})
        send(:aggregator, {:handle_result, hash, :user_name, user_name})

        # IO.puts "\e[36m[#{inspect(self())}] [#{hash}] Engagement Ratio: #{user_name} -> #{new_engagement_ratio} \e[0m"

        {:noreply, users}
    end
  end

  def calculate_engagement_per_user(user_name, hash, engagement_ratio) do
    GenServer.cast(:eru, {:engagement_per_user, user_name, hash, engagement_ratio})
  end
end
