defmodule Day16Test do
  use ExUnit.Case

  test "invalid nearby tickets are found" do
    rules = %{
      "class" => "1-3 or 5-7",
      "row" => "6-11 or 33-44",
      "seat" => "13-40 or 45-50"
    }

    nearby = [
      "7,3,47",
      "40,4,50",
      "55,2,20",
      "38,6,12"
    ]

    assert [12, 55, 4] =
      TicketDecoder.invalid_nearby_ticket_values(rules, nearby)
  end

  test "ordered list of fields is found" do
    rules = %{
      "class" => "0-1 or 4-19",
      "row" => "0-5 or 8-19",
      "seat" => "0-13 or 16-19"
    }

    yours = "11,12,13"

    nearby = [
      "3,9,18",
      "15,1,5",
      "5,14,9"
    ]

    assert %{0 => ["row"], 1 => ["class"], 2 => ["seat"]} =
      TicketDecoder.find_field_order(rules, yours, nearby)
  end
end
