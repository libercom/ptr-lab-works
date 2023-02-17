defmodule Lab3.ProcessingLineSwaper do
  use GenServer

  alias Lab3.ProcessingLine

  def init(state) do
    {:ok, state}
  end

  def start_link(worker_id, processing_line_pid) do
    GenServer.start_link(__MODULE__, {worker_id, processing_line_pid})
  end

  def handle_cast({:process_message, data}, {worker_id, processing_line_pid}) do
    case :rand.uniform(2) do
      1 -> Process.exit(self(), :kill)
      2 -> nil
    end

    swapedStrs = Enum.map(data, fn str -> String.replace(str, ["m", "n"], fn ch ->
        case ch do
          "m" -> "n"
          "n" -> "m"
        end
      end)
    end)
    {next_worker, module} = ProcessingLine.get_next_worker(processing_line_pid, worker_id)

    module.process_message(next_worker, swapedStrs)

    {:noreply, {worker_id, processing_line_pid}}
  end

  def process_message(pid, data) do
    GenServer.cast(pid, {:process_message, data})
  end
end
