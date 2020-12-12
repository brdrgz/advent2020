defmodule Ship do
  require Math

  def navigate_to(directions) do
    directions
    |> Enum.reduce(%{d: "E", x: 0, y: 0}, fn direction, position ->
      <<heading::binary-size(1), value::binary>> = direction
      move(position, heading, String.to_integer(value))
    end)
  end

  def navigate_waypoint(directions) do
    directions
    |> Enum.reduce({%{d: "E", x: 0, y: 0}, %{d: "E", x: 10, y: 1}}, fn d, p ->
      <<heading::binary-size(1), value::binary>> = d
      move(p, heading, String.to_integer(value))
    end)
    |> elem(0)
  end

  def move({ship_init, waypoint_init}, "F", value) do
    1..value
    |> Enum.reduce({ship_init, waypoint_init}, fn _, {ship_pos, waypoint_pos} ->
      waypoint_x = Map.get(waypoint_pos, :x)
      waypoint_y = Map.get(waypoint_pos, :y)
      ship_x = Map.get(ship_pos, :x)
      ship_y = Map.get(ship_pos, :y)

      new_ship_position = ship_pos
      |> Map.put(:x, waypoint_x)
      |> Map.put(:y, waypoint_y)

      new_waypoint_position = waypoint_pos
      |> Map.update!(:x, fn x_w -> x_w + (waypoint_x - ship_x) end)
      |> Map.update!(:y, fn x_y -> x_y + (waypoint_y - ship_y) end)

      {new_ship_position, new_waypoint_position}
    end)
  end
  def move({ship_position, waypoint_position}, "L", degrees) do
    rel_x = waypoint_position[:x] - ship_position[:x]
    rel_y = waypoint_position[:y] - ship_position[:y]
    radians = Math.deg2rad(degrees)

    new_rel_x = rel_x * Math.cos(radians) - rel_y * Math.sin(radians)
    new_rel_y = rel_x * Math.sin(radians) + rel_y * Math.cos(radians)

    new_waypoint_position = waypoint_position
    |> Map.put(:x, trunc(new_rel_x + ship_position[:x]))
    |> Map.put(:y, trunc(new_rel_y + ship_position[:y]))

    {ship_position, new_waypoint_position}
  end
  def move({ship_position, waypoint_position}, "R", degrees) do
    rel_x = waypoint_position[:x] - ship_position[:x]
    rel_y = waypoint_position[:y] - ship_position[:y]
    radians = -1 * Math.deg2rad(degrees)

    new_rel_x = rel_x * Math.cos(radians) - rel_y * Math.sin(radians)
    new_rel_y = rel_x * Math.sin(radians) + rel_y * Math.cos(radians)

    new_waypoint_position = waypoint_position
    |> Map.put(:x, trunc(new_rel_x + ship_position[:x]))
    |> Map.put(:y, trunc(new_rel_y + ship_position[:y]))

    {ship_position, new_waypoint_position}
  end
  def move({ship_position, waypoint_position}, heading, value) do
    {x_y, v} = cardinal_to_cartesian(heading, value)
    {ship_position, Map.update!(waypoint_position, x_y, &(&1 + v))}
  end

  def move(position, "F", value) do
    {x_y, v} = cardinal_to_cartesian(position[:d], value)
    Map.update!(position, x_y, &(&1 + v))
  end
  def move(position, "L", value) do
    new_heading = position[:d]
    |> counter_clockwise()
    |> Enum.at(Integer.floor_div(value, 90) - 1)

    Map.put(position, :d, new_heading)
  end
  def move(position, "R", value) do
    new_heading = position[:d]
    |> clockwise()
    |> Enum.at(Integer.floor_div(value, 90) - 1)

    Map.put(position, :d, new_heading)
  end
  def move(position, _, 0), do: position
  def move(position, heading, value) do
    {x_y, v} = cardinal_to_cartesian(heading, value)
    Map.update!(position, x_y, &(&1 + v))
  end

  defp cardinal_to_cartesian(heading, value) do
    case heading do
      "N" -> {:y, value}
      "S" -> {:y, -1 * value}
      "E" -> {:x, value}
      "W" -> {:x, -1 * value}
    end
  end

  defp clockwise(heading) do
    case heading do
      "N" -> ["E", "S", "W"]
      "S" -> ["W", "N", "E"]
      "E" -> ["S", "W", "N"]
      "W" -> ["N", "E", "S"]
    end
  end

  defp counter_clockwise(heading) do
    case heading do
      "N" -> ["W", "S", "E"]
      "S" -> ["E", "N", "W"]
      "E" -> ["N", "W", "S"]
      "W" -> ["S", "E", "N"]
    end
  end
end
