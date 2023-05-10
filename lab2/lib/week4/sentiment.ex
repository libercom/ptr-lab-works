defmodule Week4.Sentiment do
  use GenServer

  def init(_args) do
    IO.puts "\e[32m[#{inspect(self())}] Sentiment up\e[0m"

    url = "localhost:4000/emotion_values"

    {:ok, res} = HTTPoison.get(url, [])
    emotion_values_raw = String.replace(res.body, "\r\n", ",\"")
      |> String.replace("-", "")
      |> String.replace("\t", "\":")
    emotion_values_raw = "{\"#{emotion_values_raw}}"

    {:ok, emotion_values} = Poison.decode(emotion_values_raw, [])

    {:ok, emotion_values}
  end

  def start_link(name) do
    GenServer.start_link(__MODULE__, nil, name: name)
  end

  def handle_info({:sentiment_tweet, {hash, chunk}}, emotion_values) do
    chunk = String.replace(chunk, "event: \"message\"\n\ndata: ", "")

    case Poison.decode(chunk, []) do
      {:ok, data} ->
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

        sentiment_score = sentiment_score / Enum.count(words)

        send(:aggregator, {:handle_result, hash, :sentiment_score, sentiment_score})

        # IO.puts "\e[36m[#{inspect(self())}] [#{hash}] Sentiment Score: #{sentiment_score} \e[0m"
      {:error, _} ->
        IO.puts "\e[31m[#{inspect(self())}] Sentiment calculator down\e[0m"

        Process.exit(self(), :kill)
    end

    {:noreply, emotion_values}
  end
end
