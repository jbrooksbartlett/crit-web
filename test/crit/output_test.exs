defmodule Crit.OutputTest do
  use Crit.DataCase, async: true

  alias Crit.Comment
  alias Crit.Output

  describe "generate_review_md/2" do
    test "returns content unchanged with no comments" do
      assert Output.generate_review_md("hello\nworld", []) == "hello\nworld"
    end

    test "interleaves comments after their end_line" do
      content = "line1\nline2\nline3"

      comments = [
        %Comment{start_line: 2, end_line: 2, body: "fix this"}
      ]

      result = Output.generate_review_md(content, comments)
      assert result =~ "line2"
      assert result =~ "> **[REVIEW COMMENT — Line 2]**: fix this"
    end
  end

  describe "generate_multi_file_review_md/2" do
    test "interleaves comments per file" do
      files = [
        %{path: "a.go", content: "package a\nfunc A() {}"},
        %{path: "b.go", content: "package b\nfunc B() {}"}
      ]

      comments = [
        %Comment{start_line: 1, end_line: 1, body: "rename", file_path: "a.go"},
        %Comment{start_line: 2, end_line: 2, body: "add docs", file_path: "b.go"}
      ]

      result = Output.generate_multi_file_review_md(files, comments)
      assert result =~ "## a.go"
      assert result =~ "package a"
      assert result =~ "> **[REVIEW COMMENT — Line 1]**: rename"
      assert result =~ "## b.go"
      assert result =~ "package b"
      assert result =~ "> **[REVIEW COMMENT — Line 2]**: add docs"
    end

    test "separates files with horizontal rule" do
      files = [
        %{path: "a.go", content: "package a"},
        %{path: "b.go", content: "package b"}
      ]

      result = Output.generate_multi_file_review_md(files, [])
      assert result =~ "---"
    end

    test "handles files with no comments" do
      files = [
        %{path: "a.go", content: "package a"},
        %{path: "b.go", content: "package b"}
      ]

      result = Output.generate_multi_file_review_md(files, [])
      assert result =~ "## a.go"
      assert result =~ "## b.go"
      refute result =~ "REVIEW COMMENT"
    end
  end

  describe "multi_file_comments_json/2" do
    test "groups comments by file path" do
      ts = ~U[2026-01-01 00:00:00Z]

      files = [
        %{path: "a.go"},
        %{path: "b.go"}
      ]

      comments = [
        %Comment{
          id: "1",
          start_line: 1,
          end_line: 1,
          body: "fix",
          file_path: "a.go",
          inserted_at: ts,
          updated_at: ts
        },
        %Comment{
          id: "2",
          start_line: 1,
          end_line: 1,
          body: "ok",
          file_path: "b.go",
          inserted_at: ts,
          updated_at: ts
        }
      ]

      result = Output.multi_file_comments_json(files, comments)
      assert Map.has_key?(result.files, "a.go")
      assert Map.has_key?(result.files, "b.go")
      assert length(result.files["a.go"].comments) == 1
      assert length(result.files["b.go"].comments) == 1
    end

    test "filters out comments with nil file_path" do
      ts = ~U[2026-01-01 00:00:00Z]

      files = [%{path: "a.go"}]

      comments = [
        %Comment{
          id: "1",
          start_line: 1,
          end_line: 1,
          body: "fix",
          file_path: "a.go",
          inserted_at: ts,
          updated_at: ts
        },
        %Comment{
          id: "2",
          start_line: 1,
          end_line: 1,
          body: "orphan",
          file_path: nil,
          inserted_at: ts,
          updated_at: ts
        }
      ]

      result = Output.multi_file_comments_json(files, comments)
      assert length(result.files["a.go"].comments) == 1
    end

    test "includes empty comments list for files without comments" do
      files = [
        %{path: "a.go"},
        %{path: "b.go"}
      ]

      result = Output.multi_file_comments_json(files, [])
      assert result.files["a.go"].comments == []
      assert result.files["b.go"].comments == []
    end
  end
end
