alias Spotlight.TVDB.ApiClient

defmodule Spotlight.Search do
  alias Spotlight.TVDB.SearchResult

  def simple(query, type) do
    ApiClient.filter(%SearchResult{}, [
      query: query,
      type: type
    ])
  end
end
