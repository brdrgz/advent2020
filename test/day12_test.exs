defmodule Day12Test do
  use ExUnit.Case

  test "final destination is reached" do
    directions = [
      "F10",
      "N3",
      "F7",
      "R90",
      "F11"
    ]

    %{d: _, x: 17, y: -8} = Ship.navigate_to(directions)
  end

  test "final destination is reached using waypoints" do
    directions = [
      "F10",
      "N3",
      "F7",
      "R90",
      "F11"
    ]

    %{d: _, x: 214, y: -72} = Ship.navigate_waypoint(directions)
  end
end
