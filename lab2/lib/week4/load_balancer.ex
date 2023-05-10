defmodule Week4.LoadBalancer do
  use GenServer

  alias Week4.GenericPool

  def init(_args) do
    {:ok, 0}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: :load_balancer)
  end

  def handle_info({:print_tweet, chunk}, state) do
    # handler_actor_name = String.to_atom("printer_#{state + 1}")

    # send(handler_actor_name, {:print_tweet, chunk})
    hash = :crypto.hash(:sha256, chunk) |> Base.encode16()

    {handler_printer_pid, count_printer} = GenericPool.get_least_connected(:ps)
    {handler_sentiment_pid, count_sentiment} = GenericPool.get_least_connected(:ss)
    {handler_engagement_pid, count_engagement} = GenericPool.get_least_connected(:er)

    # IO.puts "\e[38;5;208m[Load Balancer] Sending request to printer: #{inspect(handler_printer_pid)} with only #{count_printer} messages in the mailbox\e[0m"
    # IO.puts "\e[38;5;208m[Load Balancer] Sending request to sentiment: #{inspect(handler_sentiment_pid)} with only #{count_sentiment} messages in the mailbox\e[0m"
    # IO.puts "\e[38;5;208m[Load Balancer] Sending request to engagement: #{inspect(handler_engagement_pid)} with only #{count_engagement} messages in the mailbox\e[0m"

    send(handler_printer_pid, {:print_tweet, {hash, chunk}})
    send(handler_sentiment_pid, {:sentiment_tweet, {hash, chunk}})
    send(handler_engagement_pid, {:engagement_tweet, {hash, chunk}})

    {:noreply, rem(state + 1, 3)}
  end
end
