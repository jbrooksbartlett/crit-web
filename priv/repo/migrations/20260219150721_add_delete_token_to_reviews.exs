defmodule Crit.Repo.Migrations.AddDeleteTokenToReviews do
  use Ecto.Migration

  def up do
    alter table(:reviews) do
      add :delete_token, :string, null: false, default: ""
    end

    flush()

    repo().query!(
      "UPDATE reviews SET delete_token = md5(random()::text || id::text || clock_timestamp()::text) WHERE delete_token = ''",
      [],
      log: false
    )

    create unique_index(:reviews, [:delete_token])
  end

  def down do
    drop unique_index(:reviews, [:delete_token])

    alter table(:reviews) do
      remove :delete_token
    end
  end
end
