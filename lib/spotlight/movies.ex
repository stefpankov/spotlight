require Logger
alias Spotlight.TVDB.ApiClient

defmodule Spotlight.Movies do
  alias Spotlight.TVDB.MovieBaseRecord

  def filter_movies do
    %MovieBaseRecord{}
    |> ApiClient.filter([
      country: "usa",
      lang: "eng",
      year: 2024
    ])
  end
end
