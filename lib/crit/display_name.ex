defmodule Crit.DisplayName do
  @max_length 40

  @doc """
  Normalize a display name: trim whitespace and truncate to #{@max_length} characters.
  Returns `nil` if the result is blank.
  """
  def normalize(name) when is_binary(name) do
    trimmed = name |> String.trim() |> String.slice(0, @max_length)
    if trimmed == "", do: nil, else: trimmed
  end

  def normalize(_), do: nil
end
