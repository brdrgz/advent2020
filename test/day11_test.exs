defmodule Day11Test do
  use ExUnit.Case

  test "occupied seats are found" do
    seat_map = [
      "L.LL.LL.LL",
      "LLLLLLL.LL",
      "L.L.L..L..",
      "LLLL.LL.LL",
      "L.LL.LL.LL",
      "L.LLLLL.LL",
      "..L.L.....",
      "LLLLLLLLLL",
      "L.LLLLLL.L",
      "L.LLLLL.LL"
    ]

    boarded_seat_map = [
      "#.L#.L#.L#",
      "#LLLLLL.LL",
      "L.L.L..#..",
      "##L#.#L.L#",
      "L.L#.LL.L#",
      "#.LLLL#.LL",
      "..#.L.....",
      "LLL###LLL#",
      "#.LLLLL#.L",
      "#.L#LL#.L#"
    ]

    assert ^boarded_seat_map = IslandFerry.board(seat_map)
  end
end
