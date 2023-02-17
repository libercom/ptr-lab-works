defmodule Lab3.ProcessingLineSpliter do
  use GenServer

  alias Lab3.ProcessingLine

  def init(state) do
    {:ok, state}
  end

  def start_link(worker_id, processing_line_pid) do
    GenServer.start_link(__MODULE__, {worker_id, processing_line_pid})
  end

  def handle_cast({:process_message, data}, {worker_id, processing_line_pid}) do
    ProcessingLine.start_processing(processing_line_pid, data)

    case :rand.uniform(2) do
      1 -> Process.exit(self(), :kill)
      2 -> nil
    end

    splitedStr = String.split(data, ~r/\s+/)
    {next_worker, module} = ProcessingLine.get_next_worker(processing_line_pid, worker_id)

    module.process_message(next_worker, splitedStr)

    {:noreply, {worker_id, processing_line_pid}}
  end

  def process_message(pid, data) do
    GenServer.cast(pid, {:process_message, data})
  end
end
