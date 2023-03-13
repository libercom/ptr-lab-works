defmodule Main do
  use Application

  alias Lab3.SupervisedPool
  alias Lab3.SupervisedWorker
  alias Lab3.ProcessingLine
  alias Lab3.MainSensorSupervisor
  alias Lab3.Jules

  def start(_type, _args) do
    # Lab4.get_quotes_headers_and_status()

    # data = Lab4.extract_quotes()
    # IO.inspect data

    # Lab4.persist_data(data)

    # {:ok, config} = File.read!("spotify_config.json") |> Poison.decode()


    pid = Lab4.spotify_actor_spawn()

    Lab4.spotify_authenticate(pid, self())

    receive do
      :ok -> :ok
    end

    Lab4.spotify_get_songs(pid)
    Process.sleep(100)

    IO.inspect "Create a new playlist:"
    name = IO.gets("")
    description = IO.gets("")

    Lab4.spotify_create_playlist(pid, name, description)

    IO.inspect "Add a few songs:"
    song1 = IO.gets("")
    song2 = IO.gets("")
    song3 = IO.gets("")

    Lab4.spotify_add_song(pid, song1)
    Lab4.spotify_add_song(pid, song2)
    Lab4.spotify_add_song(pid, song3)

    IO.inspect "Upload a image:"
    img = IO.gets("")

    Lab4.spotify_upload_image(pid, img)

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
