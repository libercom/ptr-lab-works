defmodule Week1.Printer do
  use GenServer

  alias Week1.MessageStore

  def init({min_load_time, max_load_time}) do
    IO.puts "\e[32m[#{inspect(self())}] Printer up\e[0m"

    bad_words = File.read!("bad_words.json") |> Poison.decode!()

    {:ok, {min_load_time, max_load_time, bad_words}}
  end

  def start_link({name, load_values}) do
    GenServer.start_link(__MODULE__, load_values, name: name)
  end

  def handle_info({:print_tweet, {hash, chunk}}, {min_load_time, max_load_time, bad_words}) do
    sleep_time = rem(:rand.uniform(1945), max_load_time - min_load_time) + min_load_time

    Process.sleep(sleep_time)

    chunk = String.replace(chunk, "event: \"message\"\n\ndata: ", "")

    case Poison.decode(chunk, []) do
      {:ok, data} ->
        text = data["message"]["tweet"]["text"]
        text = censure_message(text, bad_words)

        case MessageStore.remove_message(hash) do
          :ok ->
            IO.puts "\e[36m[#{inspect(self())}] Tweet: #{text}\e[0m"
          :error ->
            IO.inspect("MESSAGE SKIPPED")

            "\e[31m[#{inspect(self())}] Message already printed\e[0m"
        end
      {:error, _} ->
        IO.puts "\e[31m[#{inspect(self())}] Printer down\e[0m"

        Process.exit(self(), :kill)
    end

    {:noreply, {min_load_time, max_load_time, bad_words}}
  end

  def censure_message(message, bad_words) do
    Enum.reduce(bad_words, message, fn bad_word, acc ->
      String.replace(acc, bad_word, String.duplicate("*", String.length(bad_word)))
    end)
  end
end
