defmodule Lab2.Node do
  use GenServer

  def init(state) do
    {:ok, state}
  end

  def create_node(prev, val) do
    GenServer.start_link(__MODULE__, {prev, val, nil})
  end

  def handle_call({:add_node, node_val}, _from, {prev, val, _next}) do
    {:ok, next_pid} = create_node(self(), node_val)

    {:reply, next_pid, {prev, val, next_pid}}
  end

  def handle_call(:get_next, _from, {prev, val, next}) do
    {:reply, {next, val}, {prev, val, next}}
  end

  def handle_call(:get_prev, _from, {prev, val, next}) do
    {:reply, {prev, val}, {prev, val, next}}
  end

  def add_node(pid, val) do
    GenServer.call(pid, {:add_node, val})
  end

  def get_next(pid) do
    GenServer.call(pid, :get_next)
  end

  def get_prev(pid) do
    GenServer.call(pid, :get_prev)
  end
end
