defmodule Crit.Repo.Migrations.CreateReviewFiles do
  use Ecto.Migration

  def change do
    create table(:review_files, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :review_id, references(:reviews, type: :binary_id, on_delete: :delete_all), null: false
      add :file_path, :string, null: false
      add :content, :text, null: false
      add :position, :integer, null: false, default: 0

      timestamps(type: :utc_datetime)
    end

    create index(:review_files, [:review_id])
    create unique_index(:review_files, [:review_id, :file_path])
  end
end
