defmodule Day1Test do
  use ExUnit.Case

  test "pair of entries that sum to 2020 are found" do
    report = [1721, 979, 366, 299, 675, 1456]
    pair = ExpenseReport.find_pair_summing_to(report, 2020)
    assert pair == [1721, 299]
  end

  test "3-tuple of entries that sum to 2020 are found" do
    report = [1721, 979, 366, 299, 675, 1456]
    tuple = ExpenseReport.find_3_tuple_summing_to(report, 2020)
    assert tuple == [979, 675, 366]
  end
end
