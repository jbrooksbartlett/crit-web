defmodule Crit.Repo.Migrations.BackfillReviewFilesAndDropContent do
  use Ecto.Migration

  def up do
    # Backfill review_files for reviews that have content but no files yet
    execute("""
    INSERT INTO review_files (id, review_id, file_path, content, position, inserted_at, updated_at)
    SELECT gen_random_uuid(), r.id, COALESCE(r.filename, 'document'), r.content, 0, NOW(), NOW()
    FROM reviews r
    WHERE r.content IS NOT NULL
      AND NOT EXISTS (SELECT 1 FROM review_files rf WHERE rf.review_id = r.id)
    """)

    alter table(:reviews) do
      remove :content
      remove :filename
    end
  end

  def down do
    alter table(:reviews) do
      add :content, :text
      add :filename, :string
    end
  end
end
