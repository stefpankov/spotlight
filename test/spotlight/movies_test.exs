defmodule Spotlight.MoviesTest do
  use Spotlight.DataCase

  alias Spotlight.Movies

  describe "movies" do
    alias Spotlight.Movies.Movie

    import Spotlight.MoviesFixtures

    @invalid_attrs %{name: nil, external_id: nil, image_url: nil, rating: nil}

    test "list_movies/0 returns all movies" do
      movie = movie_fixture()
      assert Movies.list_movies() == [movie]
    end

    test "get_movie!/1 returns the movie with given id" do
      movie = movie_fixture()
      assert Movies.get_movie!(movie.id) == movie
    end

    test "create_movie/1 with valid data creates a movie" do
      valid_attrs = %{name: "some name", external_id: "some external_id", image_url: "some image_url", rating: 42}

      assert {:ok, %Movie{} = movie} = Movies.create_movie(valid_attrs)
      assert movie.name == "some name"
      assert movie.external_id == "some external_id"
      assert movie.image_url == "some image_url"
      assert movie.rating == 42
    end

    test "create_movie/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Movies.create_movie(@invalid_attrs)
    end

    test "update_movie/2 with valid data updates the movie" do
      movie = movie_fixture()
      update_attrs = %{name: "some updated name", external_id: "some updated external_id", image_url: "some updated image_url", rating: 43}

      assert {:ok, %Movie{} = movie} = Movies.update_movie(movie, update_attrs)
      assert movie.name == "some updated name"
      assert movie.external_id == "some updated external_id"
      assert movie.image_url == "some updated image_url"
      assert movie.rating == 43
    end

    test "update_movie/2 with invalid data returns error changeset" do
      movie = movie_fixture()
      assert {:error, %Ecto.Changeset{}} = Movies.update_movie(movie, @invalid_attrs)
      assert movie == Movies.get_movie!(movie.id)
    end

    test "delete_movie/1 deletes the movie" do
      movie = movie_fixture()
      assert {:ok, %Movie{}} = Movies.delete_movie(movie)
      assert_raise Ecto.NoResultsError, fn -> Movies.get_movie!(movie.id) end
    end

    test "change_movie/1 returns a movie changeset" do
      movie = movie_fixture()
      assert %Ecto.Changeset{} = Movies.change_movie(movie)
    end
  end
end
