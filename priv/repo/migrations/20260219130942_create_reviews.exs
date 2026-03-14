defmodule Crit.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :token, :string, null: false
      add :content, :text, null: false
      add :filename, :string
      add :last_activity_at, :utc_datetime, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:reviews, [:token])
  end
end
