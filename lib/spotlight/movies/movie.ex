defmodule Spotlight.Movies.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movies" do
    field :name, :string
    field :external_id, :string
    field :image_url, :string
    field :year, :integer
    field :rating, :integer
    belongs_to :user, Spotlight.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:external_id, :user_id, :name, :image_url, :year, :rating])
    |> validate_required([:external_id, :user_id, :name, :year])
    |> validate_number(:rating, greater_than_or_equal_to: 1, less_than_or_equal_to: 10)
    |> assoc_constraint(:user)
  end

  def validation_changeset(movie, attrs) do
    movie
    |> cast(attrs, [:external_id, :name, :image_url, :year, :rating])
    |> validate_required([:external_id, :name, :year])
    |> validate_number(:rating, greater_than_or_equal_to: 1, less_than_or_equal_to: 10)
  end
end
