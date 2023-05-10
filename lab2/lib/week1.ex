defmodule Week1 do
  def start do
    url = "localhost:4000/tweets/1"

    {:ok, _} = HTTPoison.get(url, [], stream_to: self())

    loop()
  end

  def loop do
    receive do
      %HTTPoison.AsyncChunk{:chunk => chunk} ->
        chunk = String.replace(chunk, "event: \"message\"\n\ndata: ", "")

        case Poison.decode(chunk, []) do
          {:ok, data} -> IO.inspect data["message"]["tweet"]["text"]
          {:error, _} -> IO.inspect "Panic"
        end

        loop()
    end
  end
end
