defmodule Spotlight.MoviesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Spotlight.Movies` context.
  """

  alias Spotlight.Accounts.User

  @doc """
  Generate a movie.
  """
  def movie_fixture(%User{} = user, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        user_id: user.id,
        external_id: "movie-1235",
        image_url: "some_image_url",
        name: "some_name",
        rating: 6,
        year: "2006"
      })

    {:ok, movie} =
      Spotlight.Movies.create_movie(user, attrs)

    movie
  end
end
