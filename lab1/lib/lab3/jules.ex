defmodule Lab3.Jules do
  use GenServer

  alias Lab3.Brett

  def init({failure_count, questions}) do
    Process.flag(:trap_exit, true)

    {:ok, brett_pid} = Brett.start_link(self())

    dialog()

    {:ok, {failure_count, brett_pid, questions}}
  end

  def start_link() do
    questions = [
      "What country you from!",
      "\"What\" ain't no country I know! Do they speak English in \"What?",
      "English-motherfucker-can-you-speak-it?",
      "Then you understand what I'm sayin'?",
      "Now describe what Marsellus Wallace looks like!",
      "does he look like a bitch?!"
    ]

    GenServer.start_link(__MODULE__, {0, questions})
  end

  def handle_info({:EXIT, pid, :failed}, {failure_count, brett_pid, questions}) do
    failure_count = failure_count + 1

    {:ok, new_pid} = Brett.start_link(self())

    Process.sleep(10)

    case failure_count do
      5 -> IO.inspect "[Jules] Say \"What\" again! C'mon, say \"What\" again! I dare ya, I double dare ya motherfucker, say \"What\" one more goddamn time!"
      6 -> Process.exit(new_pid, :kill)
      _ -> nil
    end

    {:noreply, {failure_count, new_pid, failure_helper(questions)}}
  end

  defp failure_helper(questions) do
    if length(questions) > 4 do
      tl(questions)
    else
      questions
    end
  end

  def handle_info({:EXIT, pid, :killed}, {failure_count, brett_pid, questions}) do
    IO.inspect "*** Jules and Tarantino kill Brett ***"

    {:stop, :killed_brett, nil}
  end

  def handle_info(:dialog, {failure_count, brett_pid, []}) do
    Process.exit(brett_pid, :kill)

    {:noreply, {failure_count, brett_pid, []}}
  end

  def handle_info(:dialog, {failure_count, brett_pid, questions}) do
    IO.inspect "[Jules] #{hd(questions)}"

    Brett.ask(brett_pid, hd(questions))

    dialog()

    {:noreply, {failure_count, brett_pid, questions}}
  end

  def handle_cast(:answer, {failure_count, brett_pid, questions}) do
    {:noreply, {failure_count, brett_pid, tl(questions)}}
  end

  defp dialog() do
    Process.send_after(self(), :dialog, 1000)
  end

  def answer(pid) do
    GenServer.cast(pid, :answer)
  end
end
