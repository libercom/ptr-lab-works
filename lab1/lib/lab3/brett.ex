defmodule Lab3.Brett do
  use GenServer

  alias Lab3.Jules

  def init({jules_pid, answers}) do
    {:ok, {jules_pid, answers}}
  end

  def start_link(jules_pid) do
    answers = %{
      "English-motherfucker-can-you-speak-it?" => "Yes",
      "Then you understand what I'm sayin'?" => "Yes",
      "Now describe what Marsellus Wallace looks like!" => "Well he's... he's... black ... and he's... he's... bald",
      "does he look like a bitch?!" => "No"
    }

    GenServer.start_link(__MODULE__, {jules_pid, answers})
  end

  def handle_cast({:ask_question, question}, {jules_pid, answers}) do
    if Map.has_key?(answers, question) do
      case :rand.uniform(5) do
        1 ->
          IO.inspect "[Brett] What?"
          Process.exit(self(), :failed)

        _ ->
          IO.inspect "[Brett] #{answers[question]}"
          Jules.answer(jules_pid)
      end
    else
      IO.inspect "[Brett] What?"
      Process.exit(self(), :failed)
    end

    {:noreply, {jules_pid, answers}}
  end

  def ask(pid, question) do
    GenServer.cast(pid, {:ask_question, question})
  end
end
