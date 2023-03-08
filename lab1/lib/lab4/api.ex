defmodule Lab4.Database do
  use GenServer

  def init(_) do
    {:ok, movies} = File.read!("movies.json") |> Poison.decode()

    {:ok, movies}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def handle_call(:get_all, _from, movies) do
    {:reply, movies, movies}
  end

  def handle_call({:get_by_id, id}, _from, movies) do
    {:reply, Enum.find(movies, nil, fn %{"id" => value} -> value == id end), movies}
  end

  def handle_cast({:add_movie, title, release_year, director}, movies) do
    movie = %{
      "id" => length(movies) * 2 + 11,
      "title" => title,
      "release_year" => release_year,
      "director" => director,
    }

    {:noreply, movies ++ [movie]}
  end

  def handle_cast({:update_movie, id, title, release_year, director}, movies) do
    movie = %{
      "id" => id,
      "title" => title,
      "release_year" => release_year,
      "director" => director,
    }

    {:noreply, Enum.filter(movies, fn %{"id" => value} -> value != id end) ++ [movie]}
  end

  def handle_cast({:delete_movie, id}, movies) do
    {:noreply, Enum.filter(movies, fn %{"id" => value} -> value != id end)}
  end

  def get_all() do
    GenServer.call(__MODULE__, :get_all)
  end

  def get_by_id(id) do
    GenServer.call(__MODULE__, {:get_by_id, id})
  end

  def add_movie(title, release_year, director) do
    GenServer.cast(__MODULE__, {:add_movie, title, release_year, director})
  end

  def update_movie(id, title, release_year, director) do
    GenServer.cast(__MODULE__, {:update_movie, id, title, release_year, director})
  end

  def delete_movie(id) do
    GenServer.cast(__MODULE__, {:delete_movie, id})
  end
end

defmodule Lab4.Api do
  use Plug.Router

  alias Lab4.Database

  plug(:match)
  plug(:dispatch)

  get "/movies" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Database.get_all() |> Poison.encode!())
  end

  get "/movies/:id" do
    movie =
      conn.path_params["id"]
      |> String.to_integer()
      |> Database.get_by_id()

    conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, movie |> Poison.encode!())
  end

  post "/movies" do
    {:ok, body, conn} = conn |> Plug.Conn.read_body()

    {:ok,
     %{
       "title" => title,
       "release_year" => release_year,
       "director" => director
     }} = body |> Poison.decode()

    Database.add_movie(title, release_year, director)

    send_resp(conn, 201, "")
  end

  put "/movies/:id" do
    id =
      conn.path_params["id"]
      |> String.to_integer()

    {:ok, body, conn} = conn |> Plug.Conn.read_body()

    {:ok,
     %{
       "title" => title,
       "release_year" => release_year,
       "director" => director
     }} = body |> Poison.decode()

    Database.update_movie(id, title, release_year, director)

    send_resp(conn, 200, "")
  end

  delete "/movies/:id" do
    conn.path_params["id"]
    |> String.to_integer()
    |> Database.delete_movie()

    send_resp(conn, 200, "")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end

defmodule Lab4.Start do
  alias Lab4.Database
  alias Lab4.Api

  def run do
    {:ok, _} = Database.start_link()
    {:ok, _} = Plug.Cowboy.http(Api, [])

    IO.puts("The server started on port 4000")
  end
end
