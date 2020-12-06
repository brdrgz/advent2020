defmodule CustomsForm do
  def group_declarations_union(forms) do
    forms
    |> String.trim()
    |> String.replace(" ", "")
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.union/2)
  end

  def group_declarations_intersection(forms) do
    forms
    |> String.trim()
    |> String.replace(" ", "")
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
  end
end
