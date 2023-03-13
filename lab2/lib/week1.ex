defmodule Week1 do
  def start do
    url = "localhost:4000/tweets/1"

    {:ok, res} = HTTPoison.get(url, [], stream_to: self())

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

  def poisson(mean) do
    lambda = :math.exp(-mean)
    k = 0
    p = 1
    poisson_loop(lambda, k, p)
  end

  defp poisson_loop(lambda, k, p) do
    u = :rand.uniform()
    p = p * u
    if p >= lambda do
      k = k + 1
      poisson_loop(lambda, k, p)
    else
      trunc(k)
    end
  end
end
