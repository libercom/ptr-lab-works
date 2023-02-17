defmodule Lab3.MainSensorSupervisor do
  use GenServer

  alias Lab3.CabinSensor
  alias Lab3.ChassisSensor
  alias Lab3.MotorSensor
  alias Lab3.WheelsSensorSupervisor

  def init(_state) do
    Process.flag(:trap_exit, true)

    {:ok, cabinSensor} = CabinSensor.start_link(self())
    {:ok, chassisSensor} = ChassisSensor.start_link(self())
    {:ok, motorSensor} = MotorSensor.start_link(self())
    {:ok, wheelsSensorSupervisor} = WheelsSensorSupervisor.start_link(self())

    {:ok,
      {
        7,
        %{
          cabinSensor => {"CabinSensor", CabinSensor},
          chassisSensor => {"ChassisSensor", ChassisSensor},
          motorSensor => {"MotorSensor", MotorSensor}
        }
      }
    }
  end

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def handle_info({:EXIT, pid, :killed}, {sensors_down, sensors}) do
    {failed_sensor_id, failed_module} = Map.get(sensors, pid)
    sensors_down = sensors_down + 1

    IO.inspect "#{failed_sensor_id} failed"
    IO.inspect "[Sensors down: #{sensors_down}]"

    if sensors_down == 3 do
      deploy_airbag()
    else
      {:ok, new_pid} = failed_module.start_link(self())

      send(self(), {:update_failed_sensors, pid, new_pid})

      {:noreply, {sensors_down, sensors}}
    end

  end

  def handle_info({:update_failed_sensors, failed_pid, new_pid}, {sensors_down, sensors}) do
    {failed_sensor_id, failed_module} = Map.get(sensors, failed_pid)

    IO.inspect "#{failed_sensor_id} sensor failed"

    {:noreply, {sensors_down, Map.delete(sensors, failed_pid) |> Map.put(new_pid, {failed_sensor_id, failed_module})}}
  end

  def handle_info({:update_sensors, new_sensors}, {sensors_down, sensors}) do
    {:noreply, {sensors_down, Map.merge(sensors, new_sensors)}}
  end

  defp deploy_airbag() do
    IO.inspect("Airbags deployed")

    Process.exit(self(), :kill)
  end

  def handle_cast(:notify_sensor_up, {sensors_down, sensors}) do
    {:noreply, {sensors_down - 1, sensors}}
  end

  def handle_cast(:notify_sensor_down, {sensors_down, sensors}) do
    sensors_down = sensors_down + 1

    IO.inspect "[Sensors down: #{sensors_down}]"

    if sensors_down == 3 do
      deploy_airbag()
    else
      {:noreply, {sensors_down, sensors}}
    end
  end

  def notify_sensor_up(pid) do
    GenServer.cast(pid, :notify_sensor_up)
  end

  def notify_sensor_down(pid) do
    GenServer.cast(pid, :notify_sensor_down)
  end

  def update_failed_sensors(pid, failed_pid, new_pid) do
    send(pid, {:update_failed_sensors, failed_pid, new_pid})
  end

  def update_sensors(pid, new_sensors) do
    send(pid, {:update_sensors, new_sensors})
  end
end
