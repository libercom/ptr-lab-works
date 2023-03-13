defmodule Lab2.Queue do
  use GenServer

  def init(queue) do
    {:ok, queue}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  def handle_call(:pop, _from, []) do
    {:reply, :error, []}
  end

  def handle_cast({:push, element}, state) do
    {:noreply, state ++ [element]}
  end

  def push(pid, val) do
    GenServer.cast(pid, {:push, val})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end
end
