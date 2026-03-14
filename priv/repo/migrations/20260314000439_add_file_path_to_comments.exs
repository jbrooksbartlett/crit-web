defmodule Crit.Repo.Migrations.AddFilePathToComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :file_path, :string
    end

    create index(:comments, [:review_id, :file_path, :start_line, :end_line])
  end
end
