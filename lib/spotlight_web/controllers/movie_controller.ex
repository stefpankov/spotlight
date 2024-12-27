defmodule SpotlightWeb.MovieController do
  alias Spotlight.Movies
  use SpotlightWeb, :controller

  def index(conn, _params) do
    {:ok, movies} = Movies.filter_movies()
    render(conn, :index, movies: movies.data)
  end
end
