defmodule Spotlight.MoviesTest do
  use Spotlight.DataCase

  alias Spotlight.Movies

  describe "movies" do
    alias Spotlight.Movies.Movie

    import Spotlight.MoviesFixtures
    import Spotlight.AccountsFixtures

    @invalid_attrs %{name: nil, external_id: nil, image_url: nil, rating: nil}

    test "list_movies/1 returns all movies" do
      user = user_fixture()
      movie = movie_fixture(user)
      assert Movies.list_movies(user) == [movie]
    end

    test "annotated_tracked/2 returns a map of tracked movies for the given external ids" do
      user = user_fixture()
      movie_fixture(user, %{external_id: "movie-123"})
      movie_fixture(user, %{external_id: "movie-487"})

      assert %{
        "movie-123" => true,
        "movie-487" => true
      } == Movies.annotated_tracked(user, ["movie-123", "movie-487", "extra-id1", "extra-id2"])
    end

    test "get_movie!/2 returns the movie with given id" do
      user = user_fixture()
      movie = movie_fixture(user)
      assert Movies.get_movie!(user, movie.id) == movie
    end

    test "create_movie/2 with valid data creates a movie" do
      user = user_fixture()
      valid_attrs = %{name: "some name", external_id: "some external_id", image_url: "some image_url", rating: 6, year: "2006"}

      assert {:ok, %Movie{} = movie} = Movies.create_movie(user, valid_attrs)
      assert movie.name == "some name"
      assert movie.external_id == "some external_id"
      assert movie.image_url == "some image_url"
      assert movie.rating == 6
      assert movie.year == 2006
    end

    test "create_movie/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Movies.create_movie(user, @invalid_attrs)
    end

    test "update_movie/2 with valid data updates the movie" do
      user = user_fixture()
      movie = movie_fixture(user)
      update_attrs = %{name: "some updated name", external_id: "some updated external_id", image_url: "some updated image_url", rating: 8}

      assert {:ok, %Movie{} = movie} = Movies.update_movie(movie, update_attrs)
      assert movie.name == "some updated name"
      assert movie.external_id == "some updated external_id"
      assert movie.image_url == "some updated image_url"
      assert movie.rating == 8
    end

    test "update_movie/2 with invalid data returns error changeset" do
      user = user_fixture()
      movie = movie_fixture(user)
      assert {:error, %Ecto.Changeset{}} = Movies.update_movie(movie, @invalid_attrs)
      assert movie == Movies.get_movie!(user, movie.id)
    end

    test "delete_movie/1 deletes the movie" do
      user = user_fixture()
      movie = movie_fixture(user)
      assert {:ok, %Movie{}} = Movies.delete_movie(movie)
      assert_raise Ecto.NoResultsError, fn -> Movies.get_movie!(user, movie.id) end
    end

    test "change_movie/1 returns a movie changeset" do
      user = user_fixture()
      movie = movie_fixture(user)
      assert %Ecto.Changeset{} = Movies.change_movie(movie)
    end
  end
end
