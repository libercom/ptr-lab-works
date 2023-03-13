defmodule Week1.Printer do
  use GenServer

  def init(load_values) do
    IO.puts "\e[32m[#{inspect(self())}] Printer up\e[0m"

    {:ok, load_values}
  end

  def start_link({name, load_values}) do
    GenServer.start_link(__MODULE__, load_values, name: name)
  end

  def handle_info({:print_tweet, chunk}, {min_load_time, max_load_time}) do
    sleep_time = rem(:rand.uniform(1945), max_load_time - min_load_time) + min_load_time

    Process.sleep(sleep_time)

    chunk = String.replace(chunk, "event: \"message\"\n\ndata: ", "")

    case Poison.decode(chunk, []) do
      {:ok, data} ->
        text = data["message"]["tweet"]["text"]

        IO.puts "\e[36m[#{inspect(self())}] Tweet: #{text}\e[0m"
      {:error, _} ->
        IO.puts "\e[31m[#{inspect(self())}] Printer down\e[0m"

        Process.exit(self(), :kill)
    end

    {:noreply, {min_load_time, max_load_time}}
  end
end
