defmodule BoardingPass do
  @rows 128
  @columns 8

  # :math.log2(@rows) -> float
  # :math.log2(@columns) -> float
  def decode(<<row_dir::binary-size(7), col_dir::binary-size(3)>>) do
    seat_row = find_seat_row(row_dir)
    seat_column = find_seat_column(col_dir)

    %{row: seat_row,
      column: seat_column,
      id: seat_row * @columns + seat_column}
  end

  defp find_seat_row(directions) do
    find_seat_row_rec(directions, 0, @rows-1)
  end

  defp find_seat_row_rec(<<dir::binary-size(1)>>, min, max) do
    case dir do
      "F" -> min
      "B" -> max
    end
  end
  defp find_seat_row_rec(<<dir::binary-size(1), rest::binary>>, min, max) do
    case dir do
      "F" -> find_seat_row_rec(rest, min, min+floor((max-min)/2))
      "B" -> find_seat_row_rec(rest, min+round((max-min)/2), max)
    end
  end

  defp find_seat_column(directions) do
    find_seat_col_rec(directions, 0, @columns-1)
  end

  defp find_seat_col_rec(<<dir::binary-size(1)>>, min, max) do
    case dir do
      "L" -> min
      "R" -> max
    end
  end
  defp find_seat_col_rec(<<dir::binary-size(1), rest::binary>>, min, max) do
    case dir do
      "L" -> find_seat_col_rec(rest, min, min+floor((max-min)/2))
      "R" -> find_seat_col_rec(rest, min+round((max-min)/2), max)
    end
  end
end
