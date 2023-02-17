defmodule Lab3.CabinSensor do
  use GenServer

  alias Lab3.MainSensorSupervisor

  def init(sensor_supervisor_pid) do
    MainSensorSupervisor.notify_sensor_up(sensor_supervisor_pid)

    measure()

    {:ok, sensor_supervisor_pid}
  end

  def start_link(sensor_supervisor_pid) do
    GenServer.start_link(__MODULE__, sensor_supervisor_pid)
  end

  def handle_info(:measure, sensor_supervisor_pid) do
    case :rand.uniform(5) do
      1 -> Process.exit(self(), :kill)
      _ -> nil
    end

    IO.inspect("Cabin sensor performs measurement")

    measure()

    {:noreply, sensor_supervisor_pid}
  end

  defp measure() do
    Process.send_after(self(), :measure, 500)
  end
end
