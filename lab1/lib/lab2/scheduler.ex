defmodule Lab2.Scheduler do
  use GenServer

  alias Lab2.Worker

  def init(specs) do
    Process.flag(:trap_exit, true)

    {:ok, specs}
  end

  def start() do
    GenServer.start_link(__MODULE__, %{})
  end

  def handle_cast({:create_worker, msg}, specs) do
    pid = Worker.start(msg)

    {:noreply, Map.put(specs, pid, msg)}
  end

  def handle_info({:EXIT, pid, :normal}, specs) do
    Process.alive?(pid)
    {:noreply, Map.delete(specs, pid)}
  end

  def handle_info({:EXIT, pid, reason}, specs) when reason != :normal do
    old_value = Map.get(specs, pid)
    new_pid = Worker.start(old_value)

    IO.inspect "#{old_value} -> Task fail"

    {:noreply, Map.delete(specs, pid) |> Map.put(new_pid, old_value)}
  end

  def create_worker(pid, msg) do
    GenServer.cast(pid, {:create_worker, msg})
  end
end
