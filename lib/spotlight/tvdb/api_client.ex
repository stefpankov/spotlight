alias Spotlight.TVDB.ReqTheTvDbAuth
alias Spotlight.TVDB.CollectionResponse

defmodule Spotlight.TVDB.ApiClient do
  alias Plug.Exception
  defprotocol Resource do
    @spec path(t) :: String.t()
    def path(t)

    @spec map_response(t, any()) :: t
    def map_response(resource, response)
  end

  defp tvdb_api_url(), do: "https://api4.thetvdb.com/v4"

  @spec filter(struct(), keyword()) :: {:ok, CollectionResponse.t()} | {:error, Exception.t()}
  def filter(resource, filters) do
    req =
      Req.new(
        base_url: tvdb_api_url(),
        url: Resource.path(resource),
        http_errors: :raise
      )
      |> ReqTheTvDbAuth.attach()

    with {:ok, %{body: resp} = _} <- Req.get(req, params: filters) do
      {:ok,
       %CollectionResponse{
         data: Enum.map(resp["data"], &Resource.map_response(resource, &1)),
         status: resp["status"],
         links: resp["links"]
       }}
    else
      error -> error
    end
  end
end
