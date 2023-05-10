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

    handler_actor_pids = Pool.get_least_connected()

    Enum.each(handler_actor_pids, fn {x, count} ->
      IO.puts "\e[38;5;208m[Load Balancer] Sending request to: #{inspect(x)} with only #{count} messages in the mailbox\e[0m"

      send(x, {:print_tweet, chunk})
    end)

    {:noreply, rem(state + 1, 3)}
  end
end
