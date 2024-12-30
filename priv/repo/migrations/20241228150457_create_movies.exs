defmodule Spotlight.Repo.Migrations.CreateMovies do
  use Ecto.Migration

  def change do
    create table(:movies) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :external_id, :string
      add :name, :string
      add :image_url, :string
      add :year, :integer
      add :rating, :integer, size: 10

      timestamps(type: :utc_datetime)
    end

    create index(:movies, [:user_id])
    create index(:movies, [:external_id])
    create unique_index(:movies, [:user_id, :external_id])
  end
end
