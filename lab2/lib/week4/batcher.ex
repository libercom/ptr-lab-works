defmodule Week4.Batcher do
  use GenServer

  def init({batch_size, time_interval}) do
    Process.send_after(self(), :timer, 10)

    {:ok, {batch_size, time_interval, 0, []}}
  end

  def start_link(batch_size, time_interval) do
    GenServer.start_link(__MODULE__, {batch_size, time_interval}, name: :batcher)
  end

  def handle_info({:handle_result, result}, {batch_size, time_interval, timer, state}) do
    state = state ++ [result]

    if length(state) >= batch_size do
      IO.puts "--------------------------------------------------------------"

      # Enum.each(state, fn res ->
      #   Tuple.to_list(res) |> Enum.each(fn term -> IO.puts term end)
      # end)

      # IO.inspect result

      GenServer.cast(:db, {:add_batch, state})

      {:noreply, {batch_size, time_interval, 0, []}}
    else
      {:noreply, {batch_size, time_interval, timer, state}}
    end
  end

  def handle_info(:timer, {batch_size, time_interval, timer, state}) do
    Process.send_after(self(), :timer, 10)

    if timer >= time_interval do
      # Enum.each(state, fn res ->
      #   Tuple.to_list(res) |> Enum.each(fn term -> IO.puts term end)
      # end)
      IO.puts "--------------------------------------------------------------"

      GenServer.cast(:db, {:add_batch, state})

      {:noreply, {batch_size, time_interval, 0, []}}
    else
      {:noreply, {batch_size, time_interval, timer + 10, state}}
    end
  end
end
