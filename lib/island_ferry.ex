defmodule IslandFerry do
  def board(seat_map) do
    row_width = seat_map |> hd() |> String.length()
    generate_new_seat_map(seat_map, row_width)
  end

  def generate_new_seat_map(map, row_width) do
    new_map =
      calculate_seat_edits(map, row_width)
      |> apply_edits(map)

    if map == new_map do
      new_map
    else
      generate_new_seat_map(new_map, row_width)
    end
  end

  defp calculate_seat_edits(map, row_width) do
    map
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, row_index}, edits ->
      sub_edits =
        row
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {seat, position}, sub_edits ->
             Map.put(sub_edits,
             {row_index, position},
             new_seat_state(map, row, row_index, seat, position, row_width))
           end)
      Map.merge(edits, sub_edits)
    end)
  end

  defp apply_edits(edits, map) do
    map
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} ->
      row
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.reduce("", fn {seat, col_index}, s ->
        s <> Map.get(edits, {row_index, col_index}, seat)
      end)
    end)
  end

  defp new_seat_state(_, _, _, state, _, _) when state == ".", do: state
  defp new_seat_state(map, row, row_index, state, position, row_width)
  when state == "L" do
    if adjacent_seats(map, row, row_index, position, row_width)
    |> Enum.any?(&(&1 == "#")) do
      state
    else
      "#"
    end
  end
  defp new_seat_state(map, row, row_index, state, position, row_width)
  when state == "#" do
    if adjacent_seats(map, row, row_index, position, row_width)
    |> Enum.count(&(&1 == "#")) >= 5 do
      "L"
    else
      state
    end
  end

  defp adjacent_left(map, row, row_index, position, row_width) do
    cond do
      position == 0 ->
        nil
      String.at(row, position - 1) == "." ->
        adjacent_left(map, row, row_index, position - 1, row_width)
      true ->
        String.at(row, position - 1)
    end
  end

  defp adjacent_right(map, row, row_index, position, row_width) do
    cond do
      position + 1 == row_width ->
        nil
      String.at(row, position + 1) == "." ->
        adjacent_right(map, row, row_index, position + 1, row_width)
      true ->
        String.at(row, position + 1)
    end
  end

  defp adjacent_up(map, row_index, position, row_width) do
    cond do
      row_index == 0 ->
        nil
      Enum.at(map, row_index - 1) |> String.at(position) == "." ->
        adjacent_up(map, row_index - 1, position, row_width)
      true ->
        Enum.at(map, row_index - 1) |> String.at(position)
    end
  end

  defp adjacent_down(map, row_index, position, row_width) do
    cond do
      map |> Enum.at(row_index + 1) |> is_nil() ->
        nil
      map |> Enum.at(row_index + 1) |> String.at(position) == "." ->
        adjacent_down(map, row_index + 1, position, row_width)
      true ->
        map |> Enum.at(row_index + 1) |> String.at(position)
    end
  end

  defp adjacent_up_left(map, row_index, position, row_width) do
    cond do
      row_index == 0 || position == 0 ->
        nil
      Enum.at(map, row_index - 1) |> String.at(position - 1) == "." ->
        adjacent_up_left(map, row_index - 1, position - 1, row_width)
      true ->
        Enum.at(map, row_index - 1) |> String.at(position - 1)
    end
  end

  defp adjacent_up_right(map, row_index, position, row_width) do
    cond do
      row_index == 0 || position + 1 == row_width ->
        nil
      Enum.at(map, row_index - 1) |> String.at(position + 1) == "." ->
        adjacent_up_right(map, row_index - 1, position + 1, row_width)
      true ->
        Enum.at(map, row_index - 1) |> String.at(position + 1)
    end
  end

  defp adjacent_down_left(map, row_index, position, row_width) do
    cond do
      map |> Enum.at(row_index + 1) |> is_nil() || position <= 0 ->
        nil
      map |> Enum.at(row_index + 1) |> String.at(position - 1) == "." ->
        adjacent_down_left(map, row_index + 1, position - 1, row_width)
      true ->
        map |> Enum.at(row_index + 1) |> String.at(position - 1)
    end
  end

  defp adjacent_down_right(map, row_index, position, row_width) do
    cond do
      map |> Enum.at(row_index + 1) |> is_nil() || position + 1 >= row_width ->
        nil
      map |> Enum.at(row_index + 1) |> String.at(position + 1) == "." ->
        adjacent_down_right(map, row_index + 1, position + 1, row_width)
      true ->
        map |> Enum.at(row_index + 1) |> String.at(position + 1)
    end
  end

  defp adjacent_seats(map, row, row_index, position, row_width) do
    [adjacent_left(map, row, row_index, position, row_width),
     adjacent_right(map, row, row_index, position, row_width),
     adjacent_up(map, row_index, position, row_width),
     adjacent_down(map, row_index, position, row_width),
     adjacent_up_left(map, row_index, position, row_width),
     adjacent_up_right(map, row_index, position, row_width),
     adjacent_down_left(map, row_index, position, row_width),
     adjacent_down_right(map, row_index, position, row_width)]
  end
end
