defmodule Week1.LoadBalancer do
  use GenServer

  alias Week1.Pool

  def init(_args) do
    {:ok, 0}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: :load_balancer)
  end

  def handle_info({:print_tweet, chunk}, state) do
    # handler_actor_name = String.to_atom("printer_#{state + 1}")

    # send(handler_actor_name, {:print_tweet, chunk})

    handler_actor_pid = Pool.get_least_connected()

    send(handler_actor_pid, {:print_tweet, chunk})

    {:noreply, rem(state + 1, 3)}
  end
end
