defmodule Week4.GenericPool do
  use Supervisor

  def init({module, actor_name, num_of_workers}) do
    children = Enum.map(1..num_of_workers, fn x ->
      worker_name = String.to_atom("#{actor_name}_#{x}")

      Supervisor.child_spec({module, worker_name}, id: worker_name)
    end)

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 10000)
  end

  def start_link(supervisor_name, module_name, actor_name, num_of_workers) do
    Supervisor.start_link(__MODULE__, {module_name, actor_name, num_of_workers}, name: supervisor_name)
  end

  def get_least_connected(supervisor_pid) do
    least_connected = Supervisor.which_children(supervisor_pid)
      |> Enum.map(fn x -> elem(x, 1) end)
      |> Enum.filter(fn x -> x != :undefined end)
      |> Enum.map(fn x ->
        case Process.info(x, :message_queue_len) do
          {_, count} -> {x, count}
          nil -> {x, 100000}
        end
      end)
      |> Enum.min_by(fn {_, count} -> count end)
  end
end
