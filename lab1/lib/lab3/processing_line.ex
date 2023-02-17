defmodule Lab3.ProcessingLine do
  use GenServer

  alias Lab3.ProcessingLineJoiner
  alias Lab3.ProcessingLineSpliter
  alias Lab3.ProcessingLineSwaper

  def init(_state) do
    Process.flag(:trap_exit, true)

    {:ok, spliter} = ProcessingLineSpliter.start_link(1, self())
    {:ok, swaper} = ProcessingLineSwaper.start_link(2, self())
    {:ok, joiner} = ProcessingLineJoiner.start_link(3, self())

    {:ok, {"",
      %{
        spliter => {1, ProcessingLineSpliter},
        swaper => {2, ProcessingLineSwaper},
        joiner => {3, ProcessingLineJoiner}
      }
    }}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def handle_call({:get_next_worker, worker_id}, _receiver, {processing_word, workers}) do
    {next_worker, {_id, module}} = Enum.find(workers, fn {_k, {id, module}} -> id == worker_id + 1 end)

    {:reply, {next_worker, module}, {processing_word, workers}}
  end

  def handle_cast({:start_processing, str}, {processing_word, workers}) do
    {:noreply, {str, workers}}
  end

  def handle_info({:EXIT, pid, :killed}, {processing_word, workers}) do
    {failed_worker_id, failed_module} = Map.get(workers, pid)
    {:ok, new_pid} = failed_module.start_link(failed_worker_id, self())

    Process.sleep(10)

    if failed_worker_id == 1 do
      failed_module.process_message(new_pid, processing_word)
    else
      {first_worker_pid, {_, first_worker_module}} = Enum.find(workers, fn {_k, {id, module}} -> id == 1 end)
      first_worker_module.process_message(first_worker_pid, processing_word)
    end

    IO.inspect "Task fail at #{failed_module}"

    {:noreply, {processing_word, Map.delete(workers, pid) |> Map.put(new_pid, {failed_worker_id, failed_module})}}
  end

  def get_next_worker(pid, worker_id) do
    GenServer.call(pid, {:get_next_worker, worker_id})
  end

  def start_processing(pid, str) do
    GenServer.cast(pid, {:start_processing, str})
  end
end
