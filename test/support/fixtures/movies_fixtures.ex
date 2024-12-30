defmodule Spotlight.MoviesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Spotlight.Movies` context.
  """

  @doc """
  Generate a movie.
  """
  def movie_fixture(attrs \\ %{}) do
    {:ok, movie} =
      attrs
      |> Enum.into(%{
        external_id: "some external_id",
        image_url: "some image_url",
        name: "some name",
        rating: 42
      })
      |> Spotlight.Movies.create_movie()

    movie
  end
end
