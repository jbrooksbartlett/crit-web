defmodule Crit.Repo.Migrations.AddAuthorDisplayNameToComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :author_display_name, :string, size: 40
    end
  end
end
