defmodule Lab3.WheelsSensorSupervisor do
  use GenServer

  alias Lab3.WheelSensor
  alias Lab3.MainSensorSupervisor

  def init(sensor_supervisor_pid) do
    Process.flag(:trap_exit, true)

    {:ok, wheel1} = WheelSensor.start_link(self())
    {:ok, wheel2} = WheelSensor.start_link(self())
    {:ok, wheel3} = WheelSensor.start_link(self())
    {:ok, wheel4} = WheelSensor.start_link(self())

    MainSensorSupervisor.update_sensors(sensor_supervisor_pid,
    %{
      wheel1 => {"Wheel1", WheelSensor},
      wheel2 => {"Wheel2", WheelSensor},
      wheel3 => {"Wheel3", WheelSensor},
      wheel4 => {"Wheel4", WheelSensor}
    })

    {:ok, sensor_supervisor_pid}
  end

  def start_link(sensor_supervisor_pid) do
    GenServer.start_link(__MODULE__, sensor_supervisor_pid)
  end

  def handle_info({:EXIT, pid, :killed}, sensor_supervisor_pid) do
    MainSensorSupervisor.notify_sensor_down(sensor_supervisor_pid)

    {:ok, new_pid} = WheelSensor.start_link(self())

    MainSensorSupervisor.update_failed_sensors(sensor_supervisor_pid, pid, new_pid)

    {:noreply, sensor_supervisor_pid}
  end

  def handle_cast(:notify_sensor_up, sensor_supervisor_pid) do
    MainSensorSupervisor.notify_sensor_up(sensor_supervisor_pid)

    {:noreply, sensor_supervisor_pid}
  end

  def notify_sensor_up(pid) do
    GenServer.cast(pid, :notify_sensor_up)
  end
end
