defmodule Lab2.Worker do
  def start(msg), do: spawn_link(fn -> execute_task(msg) end)

  def execute_task(msg) do
    case :rand.uniform(2) do
      1 -> IO.inspect("#{msg} -> Task successful")
      2 -> raise "Something went wrong"
    end
  end
end
