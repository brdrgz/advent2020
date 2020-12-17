defmodule Day17Test do
  use ExUnit.Case

  test "number of active cubes after 6 cycles is found" do
    initial_state = [
      ".#.",
      "..#",
      "###"
    ]

    assert 112 = PocketDimension.active_cubes(initial_state, 6, 3)
  end

  test "number of actice hypercubes after 6 cycles is found" do
    initial_state = [
      ".#.",
      "..#",
      "###"
    ]

    assert 848 = PocketDimension.active_hypercubes(initial_state, 6, 3)
  end
end
