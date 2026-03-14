defmodule Crit.DisplayNameTest do
  use ExUnit.Case, async: true

  alias Crit.DisplayName

  describe "normalize/1" do
    test "trims whitespace" do
      assert DisplayName.normalize("  Alice  ") == "Alice"
    end

    test "truncates to max length (40)" do
      long_name = String.duplicate("a", 50)
      result = DisplayName.normalize(long_name)
      assert String.length(result) == 40
    end

    test "returns nil for blank string" do
      assert DisplayName.normalize("") == nil
      assert DisplayName.normalize("   ") == nil
    end

    test "returns nil for non-binary input" do
      assert DisplayName.normalize(nil) == nil
      assert DisplayName.normalize(123) == nil
    end

    test "preserves valid name unchanged" do
      assert DisplayName.normalize("Alice") == "Alice"
    end

    test "handles unicode characters" do
      assert DisplayName.normalize("Ólafur") == "Ólafur"
    end

    test "trims then truncates" do
      padded = "  " <> String.duplicate("x", 50)
      result = DisplayName.normalize(padded)
      assert String.length(result) == 40
      assert result == String.duplicate("x", 40)
    end
  end
end
