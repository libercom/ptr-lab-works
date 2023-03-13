defmodule Lab3.SupervisedPool do
  use Supervisor

  alias Lab3.SupervisedWorker

  def init(workers_count) do
    children = Enum.map(1..workers_count, fn x -> Supervisor.child_spec(SupervisedWorker, id: "my_worker_#{x}") end)

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link(workers_count) do
    Supervisor.start_link(__MODULE__, workers_count, name: __MODULE__)
  end

  def get_workers(pid) do
    Supervisor.which_children(pid) |> Enum.map(fn x -> elem(x, 1) end) |> List.to_tuple
  end
end
