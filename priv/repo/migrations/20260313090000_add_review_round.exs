defmodule Crit.Repo.Migrations.AddReviewRound do
  use Ecto.Migration

  def change do
    alter table(:reviews) do
      add :review_round, :integer, default: 0
    end

    alter table(:comments) do
      add :review_round, :integer, default: 0
    end
  end
end
