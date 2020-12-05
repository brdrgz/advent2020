defmodule Day5Test do
  use ExUnit.Case

  test "seat row, column and ID are found from boarding pass" do
    assert %{row: 70, column: 7, id: 567} =
      BoardingPass.decode("BFFFBBFRRR")

    assert %{row: 14, column: 7, id: 119} =
      BoardingPass.decode("FFFBBBFRRR")

    assert %{row: 102, column: 4, id: 820} =
      BoardingPass.decode("BBFFBBFRLL")
  end
end
