defmodule Crit.Comment do
  use Crit.Schema

  schema "comments" do
    field :start_line, :integer
    field :end_line, :integer
    field :body, :string
    field :author_identity, :string
    field :author_display_name, :string
    field :review_round, :integer, default: 0
    field :file_path, :string

    belongs_to :review, Crit.Review

    timestamps(type: :utc_datetime)
  end

  @doc "Changeset for creating a comment from an imported payload."
  def create_changeset(comment, attrs) do
    comment
    |> cast(attrs, [
      :id,
      :start_line,
      :end_line,
      :body,
      :author_identity,
      :author_display_name,
      :review_round,
      :file_path
    ])
    |> validate_required([:start_line, :end_line, :body])
    |> validate_number(:start_line, greater_than: 0)
    |> validate_number(:end_line, greater_than: 0)
    |> validate_length(:body, max: 51_200, message: "must be at most 50 KB")
    |> validate_length(:author_display_name, max: 40)
    |> validate_length(:file_path, max: 500)
  end
end
