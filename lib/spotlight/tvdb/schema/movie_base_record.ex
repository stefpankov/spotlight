alias Spotlight.TVDB.ApiClient.Resource

defmodule Spotlight.TVDB.MovieBaseRecord do
  @derive Jason.Encoder
  defstruct [:id, :name, :year, :image_url]

  @type t :: %__MODULE__{
    id: integer(),
    name: String.t(),
    image_url: String.t(),
    year: String.t(),
  }

  defimpl Resource do
    alias Spotlight.TVDB.MovieBaseRecord
    def path(_), do: "/movies/filter"

    def map_response(_, r) do
      %MovieBaseRecord{
        id: r["id"],
        name: r["name"],
        year: r["year"],
        image_url: r["image_url"]
      }
    end
  end
end
