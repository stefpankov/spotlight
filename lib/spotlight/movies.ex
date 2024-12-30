require Logger
alias Spotlight.TVDB.ApiClient

defmodule Spotlight.Movies do
  import Ecto.Query, warn: false
  alias Spotlight.Accounts.User
  alias Spotlight.Repo
  alias Spotlight.TVDB.MovieBaseRecord

  @doc """
  Filters TVDB movies, as opposed to movies we're tracking.
  TODO: Extract to TVDB specific module
  """
  def filter_movies do
    %MovieBaseRecord{}
    |> ApiClient.filter(
      country: "usa",
      lang: "eng",
      year: 2024
    )
  end

  alias Spotlight.Movies.Movie

  @doc """
  Returns the list of tracked movies for a given user.

  ## Examples

      iex> list_movies(%User{})
      [%Movie{}, ...]

  """
  def list_movies(%User{} = user) do
    Movie
    |> where(user_id: ^user.id)
    |> Repo.all()
  end

  @doc """
  Given a list of external ids, returns a map where the ids are keys, and the value is true.
  Meant to be used when comparing whether the user has already tracked the given movies.

  ## Examples

      iex> annotated_tracked(%User{}, ["movie-124", "movie-789", "movie-9127"])
      %{"movie-124": true, "movie-9127": true}

  """
  def annotated_tracked(%User{}, external_ids) do
    (from m in Movie, where: m.external_id in ^external_ids)
    |> Repo.all()
    |> Enum.into(%{}, &({&1.external_id, true}))
  end

  @doc """
  Gets a single movie.

  Raises `Ecto.NoResultsError` if the Movie does not exist.

  ## Examples

      iex> get_movie!(%User{}, 123)
      %Movie{}

      iex> get_movie!(%User{}, 456)
      ** (Ecto.NoResultsError)

  """
  def get_movie!(%User{} = user, id) do
    Movie
    |> where(user_id: ^user.id)
    |> Repo.get!(id)
  end

  @doc """
  Creates a movie.

  ## Examples

      iex> create_movie(%User{}, %{field: value})
      {:ok, %Movie{}}

      iex> create_movie(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_movie(%User{} = user, attrs \\ %{}) do
    %Movie{}
    |> Movie.changeset(Map.put(attrs, :user_id, user.id))
    |> Repo.insert()
  end

  @doc """
  Updates a movie.

  ## Examples

      iex> update_movie(movie, %{field: new_value})
      {:ok, %Movie{}}

      iex> update_movie(movie, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
      {:error, :forbidden}

  """
  def update_movie(%Movie{} = movie, attrs) do
    movie
    |> Movie.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a movie.

  ## Examples

      iex> delete_movie(movie)
      {:ok, %Movie{}}

      iex> delete_movie(movie)
      {:error, %Ecto.Changeset{}}

  """
  def delete_movie(%Movie{} = movie) do
    Repo.delete(movie)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking movie changes.

  ## Examples

      iex> change_movie(movie)
      %Ecto.Changeset{data: %Movie{}}

  """
  def change_movie(%Movie{} = movie, attrs \\ %{}) do
    Movie.validation_changeset(movie, attrs)
  end
end
