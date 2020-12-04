defmodule ExpenseReport do
  def find_pair_summing_to([], _), do: []
  def find_pair_summing_to(report, sum) do
    a = Enum.max(report)
    other_entries = report -- [a]

    b = Enum.find(other_entries, fn x -> a + x == sum end)

    if b do
      [a, b]
    else
      find_pair_summing_to(other_entries, sum)
    end
  end

  def find_3_tuple_summing_to([], _), do: []
  def find_3_tuple_summing_to(report, sum) do
    a = Enum.max(report)
    other_entries = report -- [a]

    b = find_pair_summing_to(other_entries, sum - a)

    if Enum.count(b) > 0 do
      [a] ++ b
    else
      find_3_tuple_summing_to(other_entries, sum)
    end
  end
end
