defmodule Week1.AutoScaling do
  use GenServer

  alias Week1.Pool

  def init({sprint_length, expected_message_count, limit}) do
    Process.sleep(1000)

    process(sprint_length)

    {:ok, {sprint_length, expected_message_count, limit}}
  end

  def start_link({sprint_length, expected_message_count, limit}) do
    GenServer.start_link(__MODULE__, {sprint_length, expected_message_count, limit}, name: :auto_scaling)
  end

  def handle_info(:process, {sprint_length, expected_message_count, limit}) do
    avg_message_count = Pool.get_avg_message_count() |> round()

    if avg_message_count > expected_message_count do
      Pool.add_worker()
    end

    if avg_message_count < expected_message_count do
      Pool.remove_inactive_workers()
    end

    IO.inspect "[AutoScaling] Average message count: #{avg_message_count}"

    process(sprint_length)

    {:noreply, {sprint_length, expected_message_count, limit}}
  end

  def process(sprint_length) do
    Process.send_after(self(), :process, sprint_length)
  end
end
