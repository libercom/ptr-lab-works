defmodule Week1.Analytics do
  use GenServer

  def init(hashtags) do
    process()

    {:ok, hashtags}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: :analytics)
  end

  def handle_info(:process, hashtags) do

    if map_size(hashtags) != 0 do
      {most_popular_hashtag, num_appeared} = Enum.max_by(hashtags, fn {_, v} -> v end)

      IO.puts "\e[35mMost popular hashtag: #{most_popular_hashtag}, which appeared #{num_appeared} times\e[0m"
    end

    process()

    {:noreply, %{}}
  end

  def handle_info({:handle_analytics, chunk}, hashtags) do
    chunk = String.replace(chunk, "event: \"message\"\n\ndata: ", "")

    case Poison.decode(chunk, []) do
      {:ok, data} ->
        new_hashtags = Enum.map(data["message"]["tweet"]["entities"]["hashtags"], fn %{"text" => text} -> "#{text}" end)

        if length(new_hashtags) != 0 do
          {:noreply, Enum.reduce(new_hashtags, hashtags, fn hashtag, acc -> Map.update(acc, hashtag, 1, fn val -> val + 1 end) end)}
        else
          {:noreply, hashtags}
        end
      {:error, _} ->
        {:noreply, hashtags}
    end
  end

  def process() do
    Process.send_after(self(), :process, 5000)
  end
end
