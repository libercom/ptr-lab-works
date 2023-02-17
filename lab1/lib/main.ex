defmodule Main do
  use Application

  alias Lab3.SupervisedPool
  alias Lab3.SupervisedWorker
  alias Lab3.ProcessingLine
  alias Lab3.MainSensorSupervisor
  alias Lab3.Jules

  def start(_type, _args) do
    # {:ok, pid} = SupervisedPool.start_link(4)

    # IO.inspect SupervisedPool.get_workers(pid)
    # {pid1, pid2, pid3, pid4} = SupervisedPool.get_workers(pid)

    # SupervisedWorker.echo(pid1, "Hi")
    # SupervisedWorker.echo(pid2, "Hello")
    # SupervisedWorker.echo(pid3, "Ma man")
    # SupervisedWorker.echo(pid4, "Privet")

    # SupervisedWorker.kill(pid3)
    # SupervisedWorker.kill(pid4)
    # Process.sleep(10)

    # {pid1, pid2, pid3, pid4} = SupervisedPool.get_workers(pid)

    # SupervisedWorker.echo(pid3, "Wazzup")
    # SupervisedWorker.echo(pid4, "Halo")

    # IO.inspect SupervisedPool.get_workers(pid)

    # {:ok, pid} = ProcessingLine.start_link()

    # {pid1, module} = ProcessingLine.get_next_worker(pid, 0)

    # module.process_message(pid1, "Hello my little monster")

    MainSensorSupervisor.start_link()

    # Jules.start_link()

    Process.sleep(30000)

    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  # def semaphore_example(pid) do
  #   Semaphore.acquire(pid)
  #   IO.inspect("#{:erlang.pid_to_list(self())} acquired the semaphore")
  #   Process.sleep(1000)
  #   IO.inspect("#{:erlang.pid_to_list(self())} released the semaphore")
  #   Semaphore.release(pid)
  # end
end
