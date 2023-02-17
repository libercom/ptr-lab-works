defmodule Lab3.SupervisedWorker do
  use GenServer

  def init(state) do
    {:ok, state}
  end

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil)
  end

  def handle_cast(:kill, _state) do
    Process.exit(self(), :kill)

    {:noreply, nil}
  end

  def handle_cast({:echo, message}, _state) do
    IO.inspect("#{:erlang.pid_to_list(self())}: #{message}")

    {:noreply, nil}
  end

  def kill(pid) do
    GenServer.cast(pid, :kill)
  end

  def echo(pid, message) do
    GenServer.cast(pid, {:echo, message})
  end
end
