defmodule Week1.Pool do
  use Supervisor

  alias Week1.Printer

  def init(load_values) do
    children = Enum.map(1..3, fn x -> Supervisor.child_spec(
      {Printer, {String.to_atom("printer_#{x}"), load_values}},
      id: "printer_#{x}")
    end)

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link(load_values) do
    Supervisor.start_link(__MODULE__, load_values, name: __MODULE__)
  end

  def get_workers() do
    Supervisor.which_children(__MODULE__) |> Enum.map(fn x -> elem(x, 1) end) |> List.to_tuple
  end

  def get_least_connected() do
    Supervisor.which_children(__MODULE__) |> Enum.map(fn x -> elem(x, 1) end) |> Enum.min_by(fn x -> Process.info(x, :message_queue_len) end)
  end
end
