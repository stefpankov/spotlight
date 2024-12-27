defmodule Spotlight.TVDB.ReqTheTvDbAuth do
  require Logger

  @moduledoc """
  `Req` plugin for TheTVDB API authentication.

  The plugin authenticates requests to TheTVDB API.
  """

  @doc """
  Runs the plugin.

  ## Examples

      req = Req.new(http_errors: :raise) |> ReqTheTvDbAuth.attach()
      Req.get!(req, url: "https://api4.thetvdb.com/v4").body["data"]["token"]
      # Outputs:
      #=> "bearerToken"
  """
  def attach(request, opts \\ []) do
    Logger.debug("attaching TVDB auth to Req")
    request
    |> Req.Request.register_options([:tvdb_token_cache_fs_path])
    |> Req.Request.merge_options(opts)
    |> Req.Request.append_request_steps(req_tvdb_auth: &auth/1)
  end

  defp auth(%{url: %URI{scheme: "https", host: "api4.thetvdb.com", port: 443}} = request) do
    opts = request.options
    token = read_memory_cache() || read_fs_cache(opts) || request_token(opts)
    Req.Request.put_header(request, "authorization", "Bearer #{token}")
  end

  defp auth(request) do
    Logger.debug(["didn't match request for some reason:", request.url])
    request
  end

  defp read_memory_cache do
    :persistent_term.get({__MODULE__, :token}, nil)
  end

  defp write_memory_cache(token) do
    :persistent_term.put({__MODULE__, :token}, token)
  end

  defp read_fs_cache(opts) do
    case File.read(token_fs_path(opts)) do
      {:ok, ""} ->
        nil

      {:ok, token} ->
        :persistent_term.put({__MODULE__, :token}, token)
        token

      {:error, :enoent} ->
        nil
    end
  end

  defp token_fs_path(opts) do
    Path.join(
      opts[:tvdb_token_cache_fs_path] || :filename.basedir(:user_config, "req_tvdb_auth"),
      "token"
    )
  end

  defp write_fs_cache(token, opts) do
    path = token_fs_path(opts)
    File.mkdir_p!(Path.dirname(path))
    File.touch!(path)
    File.chmod!(path, 0o600)
    File.write!(path, token)
  end

  defp request_token(opts) do
    # https://github.com/apps/reqgithuboauth
    apikey = Config.read_config(:spotlight)[:tvdb_secret_key]
    url = "https://api4.thetvdb.com/v4/login"
    req = Req.new(
      url: url,
      json: %{apikey: apikey}
    )
    result = Req.post!(req).body

    token = result["data"]["token"]
    write_memory_cache(token)
    write_fs_cache(token, opts)
    token
  end
end
