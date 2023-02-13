defmodule Main do
  use Application

  alias Lab2.Queue
  alias Lab2.Print
  alias Lab2.Transform
  alias Lab2.Average
  alias Lab2.Scheduler
  alias Lab2.Semaphore
  alias Lab2.DoublyLinkedList

  def start(_type, _args) do
    # {:ok, pid} = Print.start()
    # Print.print(pid, "Hello world")
    # Print.print(pid, "Hi")
    # Print.print(pid, 2)

    # {:ok, pid} = Transform.start()
    # Transform.transform(pid, 2)
    # Transform.transform(pid, "WAZZUP BRO")
    # Transform.transform(pid, {:hi, "random text"})

    # {:ok, pid} = Average.start(0)
    # Average.increase(pid, 10)
    # Average.increase(pid, 10)
    # Average.increase(pid, 10)

    # pid = Lab2.monitored_actor_spawn()

    # Lab2.monitoring_actor_spawn(pid)
    # Process.sleep(1)
    # Lab2.monitored_actor_kill(pid)

    # {:ok, pid} = Queue.start_link()
    # IO.inspect Queue.pop(pid)
    # IO.inspect Queue.push(pid, 23)
    # IO.inspect Queue.pop(pid)

    # {:ok, pid} = Scheduler.start()
    # Scheduler.create_worker(pid, "hello world")
    # Scheduler.create_worker(pid, "how are u")
    # Scheduler.create_worker(pid, "nice")

    # pid = Semaphore.create_semaphore(1)

    # spawn(fn -> semaphore_example(pid) end)
    # spawn(fn -> semaphore_example(pid) end)

    {:ok, pid} = Semaphore.create_semaphore(1)

    spawn(fn -> semaphore_example(pid) end)
    spawn(fn -> semaphore_example(pid) end)
    spawn(fn -> semaphore_example(pid) end)

    # pid = DoublyLinkedList.create_dllist([3, 4, 5, 42])
    # IO.inspect DoublyLinkedList.traverse(pid)
    # IO.inspect DoublyLinkedList.inverse(pid)

    # {:ok, pid} = DoublyLinkedList.create_dllist([3, 4, 5, 42])
    # IO.inspect DoublyLinkedList.traverse(pid)
    # IO.inspect DoublyLinkedList.inverse(pid)

    Process.sleep(3000)

    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def semaphore_example(pid) do
    Semaphore.acquire(pid)
    IO.inspect("#{:erlang.pid_to_list(self())} acquired the semaphore")
    Process.sleep(1000)
    IO.inspect("#{:erlang.pid_to_list(self())} released the semaphore")
    Semaphore.release(pid)
  end
end
