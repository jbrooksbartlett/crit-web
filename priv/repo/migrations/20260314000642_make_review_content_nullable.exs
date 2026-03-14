defmodule Crit.Repo.Migrations.MakeReviewContentNullable do
  use Ecto.Migration

  def change do
    alter table(:reviews) do
      modify :content, :text, null: true, from: {:text, null: false}
    end
  end
end
