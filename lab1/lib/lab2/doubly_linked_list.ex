# defmodule Lab2.DoublyLinkedList do
#   def create_dllist(arr) do
#     pid = spawn(fn -> dllist_actor_loop(nil, nil) end)
#     first_pid = dllist_actor_create_helper(nil, arr, pid)

#     dllist_set_first(pid, first_pid)
#     pid
#   end

#   defp dllist_actor_create_helper(prev, [head | []], dll_pid) do
#     current_pid = node_actor_spawn(head, nil, prev)
#     dllist_set_last(dll_pid, current_pid)

#     current_pid
#   end

#   defp dllist_actor_create_helper(prev, [head | tail], dll_pid) do
#     current_pid = node_actor_spawn(head, nil, prev)
#     next_pid = dllist_actor_create_helper(current_pid, tail, dll_pid)
#     node_set_next(current_pid, next_pid)

#     current_pid
#   end

#   def dllist_actor_loop(first, last) do
#     receive do
#       {:traverse, sender} ->
#         send(sender, traverse_helper(first))
#         dllist_actor_loop(first, last)
#       {:inverse, sender} ->
#         send(sender, inverse_helper(last))
#         dllist_actor_loop(first, last)
#       {:set_first, first_pid} ->
#         dllist_actor_loop(first_pid, last)
#       {:set_last, last_pid} ->
#         dllist_actor_loop(first, last_pid)
#     end
#   end

#   def dllist_set_first(pid, first_pid), do: send(pid, {:set_first, first_pid})

#   def dllist_set_last(pid, last_pid), do: send(pid, {:set_last, last_pid})

#   def node_actor_spawn(val, next, prev), do: spawn(fn -> node_actor_loop(val, next, prev) end)

#   def node_actor_loop(val, next, prev) do
#     receive do
#       {:next, sender} ->
#         send(sender, {next, val})
#         node_actor_loop(val, next, prev)
#       {:prev, sender} ->
#         send(sender, {prev, val})
#         node_actor_loop(val, next, prev)
#       {:set_next, next_pid} ->
#         node_actor_loop(val, next_pid, prev)
#     end
#   end

#   def node_set_next(pid, next_pid) do
#     send(pid, {:set_next, next_pid})
#   end

#   defp traverse_helper(node) do
#     send(node, {:next, self()})

#     receive do
#       {nil, val} ->
#         [val]
#       {next, val} ->
#         [val] ++ traverse_helper(next)
#     end
#   end

#   defp inverse_helper(node) do
#     send(node, {:prev, self()})

#     receive do
#       {nil, val} ->
#         [val]
#       {prev, val} ->
#         [val] ++ inverse_helper(prev)
#     end
#   end

#   def traverse(pid) do
#     send(pid, {:traverse, self()})

#     receive do
#       res -> res
#     end

#   end

#   def inverse(pid) do
#     send(pid, {:inverse, self()})

#     receive do
#       res -> res
#     end
#   end
# end

defmodule Lab2.DoublyLinkedList do
  use GenServer

  alias Lab2.Node

  def init(state) do
    {:ok, state}
  end

  def create_dllist(arr) do
    state = create_dllist_helper(arr)

    GenServer.start_link(__MODULE__, state)
  end

  defp create_dllist_helper([head | tail]) do
    {:ok, first} = Node.create_node(nil, head)
    last = add_nodes_helper(first, tail)

    {first, last}
  end

  defp add_nodes_helper(prev, []), do: prev

  defp add_nodes_helper(prev, [head | tail]) do
    pid = Node.add_node(prev, head)

    add_nodes_helper(pid, tail)
  end

  def handle_call(:traverse, _from, {first, last}) do
    {:reply, traverse_helper(first), {first, last}}
  end

  defp traverse_helper(node) do
    {next, val} = Node.get_next(node)

    case next do
      nil ->
        [val]
      _ ->
        [val] ++ traverse_helper(next)
    end
  end

  def handle_call(:inverse, _from, {first, last}) do
    {:reply, inverse_helper(last), {first, last}}
  end

  defp inverse_helper(node) do
    {next, val} = Node.get_prev(node)

    case next do
      nil ->
        [val]
      _ ->
        [val] ++ inverse_helper(next)
    end
  end

  def traverse(pid) do
    GenServer.call(pid, :traverse)
  end

  def inverse(pid) do
    GenServer.call(pid, :inverse)
  end
end
