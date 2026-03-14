defmodule Crit.ReviewFileTest do
  use Crit.DataCase, async: true

  alias Crit.ReviewFile

  describe "create_changeset/2" do
    test "valid changeset with required fields" do
      changeset =
        ReviewFile.create_changeset(%ReviewFile{}, %{
          "file_path" => "src/main.go",
          "content" => "package main",
          "position" => 0
        })

      assert changeset.valid?
    end

    test "invalid without file_path" do
      changeset =
        ReviewFile.create_changeset(%ReviewFile{}, %{
          "content" => "package main",
          "position" => 0
        })

      refute changeset.valid?
    end

    test "invalid without content" do
      changeset =
        ReviewFile.create_changeset(%ReviewFile{}, %{
          "file_path" => "src/main.go",
          "position" => 0
        })

      refute changeset.valid?
    end

    test "enforces content max length of 2 MB" do
      big = String.duplicate("x", 2_097_153)

      changeset =
        ReviewFile.create_changeset(%ReviewFile{}, %{
          "file_path" => "big.txt",
          "content" => big,
          "position" => 0
        })

      refute changeset.valid?
    end

    test "enforces file_path max length of 500" do
      long_path = String.duplicate("a/", 251)

      changeset =
        ReviewFile.create_changeset(%ReviewFile{}, %{
          "file_path" => long_path,
          "content" => "ok",
          "position" => 0
        })

      refute changeset.valid?

      assert {"should be at most %{count} character(s)", _} =
               changeset.errors[:file_path]
    end

    test "defaults position to 0" do
      changeset =
        ReviewFile.create_changeset(%ReviewFile{}, %{
          "file_path" => "src/main.go",
          "content" => "package main"
        })

      assert changeset.valid?
      assert Ecto.Changeset.get_field(changeset, :position) == 0
    end
  end
end
