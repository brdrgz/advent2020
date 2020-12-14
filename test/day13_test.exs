defmodule Day13Test do
  use ExUnit.Case

  test "earliest bus is found" do
    {earliest, schedule} = {939, [7, 13, 59, 31, 19]}
    assert {944, 59} == ShuttleService.next_bus(earliest, schedule)
  end

  test "earliest fleet that departs in sync is found" do
    schedule = "7,13,x,x,59,x,31,19"
    assert 1068781 == ShuttleService.earliest_fleet(schedule)
  end
end
