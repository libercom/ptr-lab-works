defmodule Week1.MessageStore do
  use GenServer

  def init(args) do
    {:ok, args}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: :message_store)
  end

  def handle_cast({:add_message, chunk}, state) do
    hash = :crypto.hash(:sha256, chunk) |> Base.encode16()

    state = Map.put(state, hash, chunk)

    send(:load_balancer, {:print_tweet, {hash, chunk}})

    {:noreply, state}
  end

  def handle_call({:remove_message, hash}, _from, state) do
    if Map.get(state, hash) != nil do
      state = Map.delete(state, hash)

      {:reply, :ok, state}
    else
      {:reply, :error, state}
    end
  end

  def add_message(chunk) do
    GenServer.cast(:message_store, {:add_message, chunk})
  end

  def remove_message(hash) do
    GenServer.call(:message_store, {:remove_message, hash})
  end
end
