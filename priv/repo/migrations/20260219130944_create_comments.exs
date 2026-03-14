defmodule Crit.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :review_id, references(:reviews, on_delete: :delete_all, type: :binary_id), null: false
      add :start_line, :integer, null: false
      add :end_line, :integer, null: false
      add :body, :text, null: false
      add :author_identity, :string

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:review_id])
  end
end
