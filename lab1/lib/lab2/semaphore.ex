# defmodule Lab2.Semaphore do
#   def create_semaphore(count), do: spawn(fn -> semaphore_loop(count, []) end)

#   def semaphore_loop(count, queue) do
#     receive do
#       {:acquire, sender} ->
#         if count > 0 do
#           send(sender, :ok)
#           semaphore_loop(count - 1, queue)
#         else
#           send(sender, :wait)
#           semaphore_loop(count, queue ++ [sender])
#         end

#       :release ->
#         {sent, new_queue} = release_helper(queue)

#         case sent do
#           true -> semaphore_loop(count, new_queue)
#           false -> semaphore_loop(count + 1, new_queue)
#         end
#     end
#   end

#   defp release_helper([]), do: {false, []}

#   defp release_helper([head | tail]) do
#     if Process.alive?(head) do
#       send(head, :ok)

#       {true, tail}
#     else
#       release_helper(tail)
#     end
#   end

#   def acquire(pid) do
#     send(pid, {:acquire, self()})

#     receive do
#       :ok -> :ok
#       :wait ->
#         IO.inspect("#{:erlang.pid_to_list(self())} tried to acquire semaphore, waiting...")

#         receive do
#           :ok -> :ok
#         end
#     end
#   end

#   def release(pid) do
#     send(pid, :release)
#   end
# end

defmodule Lab2.Semaphore do
  use GenServer

  def init(state) do
    {:ok, state}
  end

  def create_semaphore(count) do
    GenServer.start_link(__MODULE__, {count, []})
  end

  def handle_call(:acquire, {pid, _ref}, {count, queue}) do
    case count > 0 do
      true -> {:reply, :ok, {count - 1, queue}}
      false -> {:reply, :wait, {count, queue ++ [pid]}}
    end
  end

  def handle_cast(:release, {count, queue}) do
    {sent, new_queue} = release_helper(queue)

    case sent do
      true -> {:noreply, {count, new_queue}}
      false -> {:noreply, {count + 1, new_queue}}
    end
  end

  defp release_helper([]), do: {false, []}

  defp release_helper([head | tail]) do
    if Process.alive?(head) do
      send(head, :ok)

      {true, tail}
    else
      release_helper(tail)
    end
  end

  def acquire(pid) do
    response = GenServer.call(pid, :acquire)

    case response do
      :ok -> :ok
      :wait ->
        IO.inspect("#{:erlang.pid_to_list(self())} tried to acquire semaphore, waiting...")

        receive do
          :ok -> :ok
        end
    end
  end
  def release(pid) do
    GenServer.cast(pid, :release)
  end
end
