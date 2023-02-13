defmodule Lab2.Average do
  use GenServer

  def init(average) do
    {:ok, average}
  end

  def start(start_value) do
    GenServer.start_link(__MODULE__, start_value)
  end

  def handle_cast(val, average) when is_number(val) do
    new_avg = (average + val) / 2
    IO.inspect("Current average is #{new_avg}")

    {:noreply, new_avg}
  end

  def handle_cast(val, average) do
    {:noreply, average}
  end

  def increase(pid, val) do
    GenServer.cast(pid, val)
  end
end
