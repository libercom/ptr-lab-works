defmodule Lab3.ProcessingLineJoiner do
  use GenServer

  def init(state) do
    {:ok, state}
  end

  def start_link(worker_id, processing_line_pid) do
    GenServer.start_link(__MODULE__, {worker_id, processing_line_pid})
  end

  def handle_cast({:process_message, data}, {worker_id, _processing_line_pid}) do
    case :rand.uniform(2) do
      1 -> Process.exit(self(), :kill)
      2 -> nil
    end

    Enum.join(data, " ") |> IO.inspect

    {:noreply, worker_id}
  end

  def process_message(pid, data) do
    GenServer.cast(pid, {:process_message, data})
  end
end
