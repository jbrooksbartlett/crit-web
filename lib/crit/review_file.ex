defmodule Crit.ReviewFile do
  use Crit.Schema

  schema "review_files" do
    field :file_path, :string
    field :content, :string
    field :position, :integer, default: 0

    belongs_to :review, Crit.Review

    timestamps(type: :utc_datetime)
  end

  def create_changeset(review_file, attrs) do
    review_file
    |> cast(attrs, [:file_path, :content, :position])
    |> validate_required([:file_path, :content])
    |> validate_length(:content, max: 2_097_152, message: "must be at most 2 MB")
    |> validate_length(:file_path, max: 500)
  end
end
