defmodule Week1.Pool do
  use Supervisor

  alias Week1.Printer

  def init(load_values) do
    children = Enum.map(1..3, fn x -> Supervisor.child_spec(
      {Printer, {String.to_atom("printer_#{x}"), load_values}},
      id: "printer_#{x}")
    end)

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 10000)
  end

  def start_link(load_values) do
    Supervisor.start_link(__MODULE__, load_values, name: __MODULE__)
  end

  def get_workers() do
    Supervisor.which_children(__MODULE__) |> Enum.map(fn x -> elem(x, 1) end) |> List.to_tuple
  end

  def get_least_connected() do
    least_connected_pids = Supervisor.which_children(__MODULE__)
      |> Enum.map(fn x -> elem(x, 1) end)
      |> Enum.filter(fn x -> x != :undefined end)
      |> Enum.map(fn x ->
          case Process.info(x, :message_queue_len) do
            {_, count} -> {x, count}
            nil -> {x, 100000}
          end
        end)
      |> Enum.sort(fn {_, x}, {_, y} -> x < y end)
      |> Enum.take(2)

    childrens_message_count = Supervisor.which_children(__MODULE__)
      |> Enum.map(fn x -> elem(x, 1) end)
      |> Enum.filter(fn x -> x != :undefined end)
      |> Enum.map(fn x ->
        case Process.info(x, :message_queue_len) do
          {:message_queue_len, messages_count} -> {x, messages_count}
          nil -> nil
        end
      end)

    IO.puts "\e[38;5;208m[Workers Pool] #{inspect(childrens_message_count)}"

      # if least_connected_pid != :undefined do
      #   case Process.info(least_connected_pid, :message_queue_len) do
      #     {:message_queue_len, messages_count} -> {least_connected_pid, messages_count}
      #     nil -> get_least_connected()
      #   end
      # else
      #   get_least_connected()
      # end
    least_connected_pids
  end

  def get_avg_message_count() do
    children_message_counts = Supervisor.which_children(__MODULE__)
    |> Enum.map(fn x -> elem(x, 1) end)
    |> Enum.filter(fn x -> x != :undefined end)
    |> Enum.map(fn x ->
      case Process.info(x, :message_queue_len) do
        {:message_queue_len, messages_count} -> messages_count
        nil -> 0
      end
    end)

    if length(children_message_counts) == 0 do
      Supervisor.which_children(__MODULE__) |> length()
    else
      Enum.sum(children_message_counts) / length(children_message_counts)
    end
  end

  def remove_inactive_workers() do
    children_pid = Supervisor.which_children(__MODULE__)
      |> Enum.map(fn x -> {elem(x, 0), elem(x, 1)} end)
      |> Enum.filter(fn x -> x != :undefined end)
      |> Enum.map(fn {id, pid} ->
        case Process.info(pid, :message_queue_len) do
          {:message_queue_len, messages_count} -> {id, messages_count}
          nil -> {id, 0}
        end
      end)
      |> Enum.filter(fn x -> elem(x, 1) == 0 end)
      |> Enum.map(fn x -> elem(x, 0) end)
      |> Enum.take(1)

      children_count = Supervisor.which_children(__MODULE__) |> Enum.count()

      if children_count > 1 and children_pid != [] do
        IO.inspect "[AutoScaling] Removed child: #{inspect(hd(children_pid))}"
        Supervisor.terminate_child(__MODULE__, hd(children_pid))
        Supervisor.delete_child(__MODULE__, hd(children_pid))
      end
    end

    def add_worker() do
      x = Supervisor.which_children(__MODULE__) |> Enum.count()
      x = x + 1

      child = Supervisor.child_spec({Printer, {String.to_atom("printer_#{x}"), {50, 100}}}, id: "printer_#{x}")

    IO.inspect "[AutoScaling] Added child: printer_#{x}"
    Supervisor.start_child(__MODULE__, child)
  end
end
