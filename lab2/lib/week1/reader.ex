defmodule Week1.Reader do
  use GenServer

  alias Week1.MessageStore

  def init(url) do
    {:ok, res} = HTTPoison.get(url, [], stream_to: self())

    {:ok, url}
  end

  def start_link(url, name) do
    GenServer.start_link(__MODULE__, url, name: name)
  end

  def handle_info(%HTTPoison.AsyncChunk{:chunk => chunk}, url) do
    # MessageStore.add_message(chunk)
    send(:load_balancer, {:print_tweet, chunk})

    {:noreply, url}
  end

  def handle_info(_message, url) do
    {:noreply, url}
  end
end
