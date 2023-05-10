defmodule Week4.Printer do
  use GenServer

  def init(_args) do
    IO.puts "\e[32m[#{inspect(self())}] Printer up\e[0m"

    bad_words = File.read!("bad_words.json") |> Poison.decode!()

    {:ok, bad_words}
  end

  def start_link(name) do
    GenServer.start_link(__MODULE__, nil, name: name)
  end

  def handle_info({:print_tweet, {hash, chunk}}, bad_words) do
    chunk = String.replace(chunk, "event: \"message\"\n\ndata: ", "")

    case Poison.decode(chunk, []) do
      {:ok, data} ->
        text = data["message"]["tweet"]["text"]
        text = censure_message(text, bad_words)

        retweet = data["message"]["tweet"]["retweeted_status"]

        if retweet != nil do
          send(:load_balancer, {:print_tweet, Poison.encode!(%{"message" => %{"tweet" => retweet}})})
        end

        # IO.puts "\e[36m[#{inspect(self())}] [#{hash}] Tweet: #{text}\e[0m"

        send(:aggregator, {:handle_result, hash, :text, text})
      {:error, _} ->
        IO.puts "\e[31m[#{inspect(self())}] Printer down\e[0m"

        Process.exit(self(), :kill)
    end

    {:noreply, bad_words}
  end

  def censure_message(message, bad_words) do
    Enum.reduce(bad_words, message, fn bad_word, acc ->
      String.replace(acc, bad_word, String.duplicate("*", String.length(bad_word)))
    end)
  end
end
