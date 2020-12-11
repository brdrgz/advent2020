defmodule Day10Test do
  use ExUnit.Case

  test "calculates distribution of joltage differences" do
    adapter_joltage_ratings = [
      16,
      10,
      15,
      5,
      1,
      11,
      7,
      19,
      6,
      12,
      4
    ]

    assert %{one_jolt: 7, three_jolt: 5} =
      JoltageAdapter.distribution(adapter_joltage_ratings)
  end

  test "calculates distribution of more joltage differences" do
    adapter_joltage_ratings = [
      28,
      33,
      18,
      42,
      31,
      14,
      46,
      20,
      48,
      47,
      24,
      23,
      49,
      45,
      19,
      38,
      39,
      11,
      1,
      32,
      25,
      35,
      8,
      17,
      7,
      9,
      4,
      2,
      34,
      10,
      3
    ]

    assert %{one_jolt: 22, three_jolt: 10} =
      JoltageAdapter.distribution(adapter_joltage_ratings)
  end

  test "number of possible arrangements of adapters to connect from "
  <> "source to device are found" do
    adapter_joltage_ratings = [
      16,
      10,
      15,
      5,
      1,
      11,
      7,
      19,
      6,
      12,
      4
    ]

    assert 8 == JoltageAdapter.arrangements(adapter_joltage_ratings)
  end

  test "(large) number of possible arrangements of adapters to connect from "
  <> "source to device are found" do
    adapter_joltage_ratings = [
      28,
      33,
      18,
      42,
      31,
      14,
      46,
      20,
      48,
      47,
      24,
      23,
      49,
      45,
      19,
      38,
      39,
      11,
      1,
      32,
      25,
      35,
      8,
      17,
      7,
      9,
      4,
      2,
      34,
      10,
      3
    ]

    assert 19208 == JoltageAdapter.arrangements(adapter_joltage_ratings)
  end
end
