defmodule Day15Test do
  use ExUnit.Case

  test "2020th number spoken is found" do
    first_numbers = ["0", "3", "6"]
    assert 436 == MemoryGame.nth_number(first_numbers, 2020)
  end

  test "30_000_000th number spoken is found" do
    first_numbers = ["0", "3", "6"]
    assert 175594 == MemoryGame.nth_number(first_numbers, 30000000)
  end
end
