defmodule Lab2.Print do
  use GenServer

  def init(args) do
    {:ok, args}
  end

  def start() do
    GenServer.start_link(__MODULE__, nil)
  end

  def handle_cast(val, state) do
    IO.inspect(val)

    {:noreply, state}
  end

  def print(pid, msg) do
    GenServer.cast(pid, msg)
  end
end
