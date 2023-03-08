defmodule Lab4 do
  def get_quotes_headers_and_status() do
    url = "https://quotes.toscrape.com"

    {:ok, response} = HTTPoison.get(url)
    status_code = response.status_code
    headers = response.headers
    body = response.body

    IO.puts "Status code: #{status_code}"
    IO.puts "\nHeaders:\n"
    Enum.each(headers, fn {x, y} -> IO.inspect "#{x}: #{y}" end)
    IO.puts "\nBody:\n"
    IO.puts body
  end

  def extract_quotes() do
    url = "https://quotes.toscrape.com"

    {:ok, response} = HTTPoison.get(url)
    body = response.body

    {:ok, html} = Floki.parse_fragment(body)
    quotes = Floki.find(html, ".quote")

    Enum.map(quotes, fn {_, _, x} ->
      [quote_elem | rest] = x
      quote_content = hd(elem(quote_elem, 2))
      tags = Floki.find(rest, "a.tag") |> Enum.map(fn x -> hd(elem(x, 2)) end)

      %{:quote_text => String.slice(quote_content, 1..-2), :quote_tags => tags}
    end)
  end

  def persist_data(data) do
    json = Poison.encode!(data, pretty: true)

    File.write("quotes.json", json)
  end

  def img_to_base64(img_path) do
    img_path = String.trim(img_path)
    data = File.read!(img_path)
    base64 = Base.encode64(data)

    base64
  end

  def spotify_actor_spawn() do
    {:ok, config} = File.read!("spotify_config.json") |> Poison.decode()

    spawn(fn -> spotify_actor_loop(config, nil, nil) end)
  end

  defp spotify_actor_loop(config, access_token, playlist_id) do
    receive do
      {:authenticate, sender} ->
        get_auth_code(config)
        access_token = IO.gets("") |> String.trim() |> Lab4.get_token(config)

        send(sender, :ok)

        spotify_actor_loop(config, access_token, playlist_id)

      :get_songs ->
        {:ok, response} = HTTPoison.get(
          "https://api.spotify.com/v1/me/tracks?offset=50",
          [{"Authorization", "Bearer #{access_token}"}]
        )

        {:ok, %{"items" => items}} = response.body |> Poison.decode()

        IO.inspect Enum.map(items, fn %{"track" => track} -> %{:track_name => track["name"], :track_id => track["id"]} end)

        spotify_actor_loop(config, access_token, playlist_id)

      {:add_song, song_id} ->
        song_id = String.trim(song_id)

        {:ok, response} = HTTPoison.post(
          "https://api.spotify.com/v1/playlists/#{playlist_id}/tracks?uris=spotify:track:#{song_id}",
          "",
          [{"Authorization", "Bearer #{access_token}"}]
        )

        spotify_actor_loop(config, access_token, playlist_id)

      {:create_playlist, name, description} ->
        %{"user_id" => user_id} = config

        {:ok, response} = HTTPoison.post(
          "https://api.spotify.com/v1/users/#{user_id}/playlists",
          %{name: name, description: description, public: true} |> Poison.encode!(),
          [{"Content-Type", "application/json"}, {"Authorization", "Bearer #{access_token}"}]
        )

        {:ok, %{"uri" => uri}} = response.body |> Poison.decode()
        [_, _, playlist_id] = uri |> String.split(":")

        spotify_actor_loop(config, access_token, playlist_id)

      {:upload_image, img_path} ->
        {:ok, response} = HTTPoison.put(
          "https://api.spotify.com/v1/playlists/#{playlist_id}/images",
          img_to_base64(img_path),
          [{"Authorization", "Bearer #{access_token}"}]
        )

        spotify_actor_loop(config, access_token, playlist_id)
    end
  end

  def get_auth_code(config) do
    url = "https://accounts.spotify.com/authorize"

    %{
      "redirect_uri" => redirect_uri,
      "client_id" => client_id,
      "scope" => scope,
    } = config

    scope = String.replace(scope, " ", "%20")
    encoded_redirect_uri = URI.encode_www_form(redirect_uri)

    auth_url = "#{url}?response_type=code&client_id=#{client_id}&scope=#{scope}&redirect_uri=#{encoded_redirect_uri}"

    IO.puts auth_url
  end

  def get_token(authorization_code, config) do
    url = "https://accounts.spotify.com/api/token"

    %{
      "redirect_uri" => redirect_uri,
      "client_id" => client_id,
      "client_secret" => client_secret,
      "grant_type" => grant_type,
    } = config

    {:ok, response} = HTTPoison.post(
      url,
      "grant_type=#{grant_type}&code=#{authorization_code}&redirect_uri=#{redirect_uri}",
      [
        {"Content-Type", "application/x-www-form-urlencoded"},
        {"Authorization", "Basic #{Base.encode64("#{client_id}:#{client_secret}")}"}
      ]
    )

    {:ok, body} = response.body |> Poison.decode()

    access_token = body["access_token"]

    access_token
  end

  def spotify_authenticate(pid, sender) do
    send(pid, {:authenticate, sender})
  end

  def spotify_get_songs(pid) do
    send(pid, :get_songs)
  end

  def spotify_create_playlist(pid, name, description) do
    send(pid, {:create_playlist, name, description})
  end

  def spotify_add_song(pid, song_id) do
    send(pid, {:add_song, song_id})
  end

  def spotify_upload_image(pid, img_path) do
    send(pid, {:upload_image, img_path})
  end
end
