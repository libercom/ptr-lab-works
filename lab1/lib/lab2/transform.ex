defmodule Lab2.Transform do
  use GenServer

  def init(args) do
    {:ok, args}
  end

  def start() do
    GenServer.start_link(__MODULE__, nil)
  end

  def handle_cast(val, state) when is_number(val) do
    IO.inspect("Received: #{val + 1}")

    {:noreply, state}
  end

  def handle_cast(val, state) when is_bitstring(val) do
    IO.inspect("Received: #{String.downcase(val)}")

    {:noreply, state}
  end

  def handle_cast(val, state) do
    IO.inspect("Received: I dont know how to HANDLE this!")

    {:noreply, state}
  end

  def transform(pid, val) do
    GenServer.cast(pid, val)
  end
end
