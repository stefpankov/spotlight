alias Spotlight.TVDB.ApiClient.Resource

defmodule Spotlight.TVDB.SearchResult do
  defstruct [:id, :name, :image_url, :type, :year]

  @type t :: %__MODULE__{
    id: integer(),
    name: String.t(),
    image_url: String.t(),
    type: String.t(),
    year: String.t(),
  }

  defimpl Resource do
    alias Spotlight.TVDB.SearchResult
    def path(_), do: "/search"

    def map_response(_, r) do
      %SearchResult{
        id: r["id"],
        name: r["name"],
        image_url: r["image_url"],
        type: r["type"],
        year: r["year"]
      }
    end
  end
end
