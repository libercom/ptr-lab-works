defmodule Lab2 do
  def print_actor_spawn(), do: spawn(&print_actor_loop/0)

  def print_actor_loop() do
    receive do
      msg -> IO.inspect(msg)
        print_actor_loop()
    end
  end

  def transform_actor_spawn(), do: spawn(&transform_actor_loop/0)

  def transform_actor_loop() do
    receive do
      num when is_integer(num) -> IO.inspect("Received: #{num + 1}")
        transform_actor_loop()
      str when is_bitstring(str) -> IO.inspect("Received: #{String.downcase(str)}")
        transform_actor_loop()
      _ -> IO.inspect("Received: I dont know how to HANDLE this!")
        transform_actor_loop()
    end
  end

  def monitored_actor_spawn() do
    spawn(fn ->
      receive do
        :kill ->
          Process.exit(self(), :killed)
      end
    end)
  end

  def monitored_actor_kill(pid), do: send(pid, :kill)

  def monitoring_actor_spawn(pid) do
    spawn(fn ->
      Process.monitor(pid)

      receive do
        {:DOWN, _ref, :process, _pid, :killed} -> IO.inspect("We lost our last agent. Rest in peace my brother")
      end
    end)
  end

  def average_actor_spawn(initial_state), do: spawn(fn -> average_actor_loop(initial_state) end)

  def average_actor_increase(pid, val), do: send(pid, val)

  def average_actor_loop(state) do
    receive do
      num when is_number(num) ->
        IO.inspect("Current average is #{(num + state) / 2}")
        average_actor_loop((num + state) / 2)
      _ -> average_actor_loop(state)
    end
  end
end
