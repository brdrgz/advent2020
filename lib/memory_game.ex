defmodule MemoryGame do
  def nth_number(first_numbers, n) do
    {turn_numbers, last_number} = first_numbers
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.reduce({%{}, 0}, fn {num, idx}, {numbers, _} ->
        {Map.put(numbers, num, {nil, idx, false}), num}
    end)

    turn_numbers_until(turn_numbers, last_number, n) |> elem(1)
  end

  defp turn_numbers_until(turn_numbers, prev, n) do
    Kernel.map_size(turn_numbers)..n-1
    |> Enum.reduce({turn_numbers, prev}, fn i, {numbers, acc_prev} ->
      {last_last_spoken_at, last_spoken_at, spoken_before?} =
        Map.get(numbers, acc_prev)

      case {last_last_spoken_at, last_spoken_at, spoken_before?} do
        {_, _, false} ->
          {
            Map.update(numbers, 0, {nil, i, false}, fn {_, lsa, _} ->
              {lsa, i, true}
            end),
            0
          }
        {_, _, true} ->
          value_spoken = last_spoken_at - last_last_spoken_at
          {
            Map.update(numbers, value_spoken, {nil, i, false}, fn {_, lsa, _} ->
              {lsa, i, true}
            end),
            value_spoken
          }
      end
    end)
  end
end
