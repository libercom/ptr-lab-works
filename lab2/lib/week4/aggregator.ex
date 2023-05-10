defmodule Week4.Aggregator do
  use GenServer

  def init(_args) do
    {:ok, %{}}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: :aggregator)
  end

  def handle_info({:handle_result, hash, result_type, result}, state) do
    case Map.get(state, hash) do
      nil ->
        state = Map.put(state, hash, %{result_type => result})

        {:noreply, state}
      results ->
        results = Map.put(results, result_type, result)

        if map_size(results) == 5 do
          state = Map.delete(state, hash)

          send(:batcher, {:handle_result, results})

          {:noreply, state}
        else
          state = Map.put(state, hash, results)

          {:noreply, state}
        end
    end
  end
end
