defmodule JoltageAdapter do
  use Agent

  def distribution(ratings) do
    ratings
    |> Enum.sort()
    |> Enum.reduce({0, %{one_jolt: 0, three_jolt: 1}}, fn x, {x_1, d_acc} ->
      difference = x - x_1
      case difference do
        1 ->
          {x, Map.update!(d_acc, :one_jolt, &(&1 + 1))}
        3 ->
          {x, Map.update!(d_acc, :three_jolt, &(&1 + 1))}
      end
    end)
    |> elem(1)
  end

  def arrangements(ratings) do
    sorted_ratings =
      ratings
      |> Enum.sort()

    source_rating = 0
    device_adapter_rating = List.last(sorted_ratings) + 3

    {:ok, pid} = Agent.start_link(fn -> %{} end, name: __MODULE__)

    count_arrangements(sorted_ratings, source_rating, device_adapter_rating, pid)
  end

  defp count_arrangements_rec([], out, device, _) when out != device do
    0
  end
  defp count_arrangements_rec(_, out, device, _) when out == device do
    1
  end
  defp count_arrangements_rec([input | rest], out, device, pid) when out != input do
    count_arrangements_rec(rest, out, device, pid)
  end
  defp count_arrangements_rec([input | rest], out, device, pid) when out == input do
    count_arrangements(rest, out, device, pid)
  end
  defp count_arrangements(ratings, source, device, pid) do
    a = Agent.get(pid, fn state -> state end) |> Map.get("#{source+1}")
    a = if is_nil(a) do
          count_arrangements_rec(ratings, source + 1, device, pid)
        else
          a
        end

    b = Agent.get(pid, fn state -> state end) |> Map.get("#{source+2}")
    b = if is_nil(b) do
          count_arrangements_rec(ratings, source + 2, device, pid)
        else
          b
        end

    c = Agent.get(pid, fn state -> state end) |> Map.get("#{source+3}")
    c = if is_nil(c) do
          count_arrangements_rec(ratings, source + 3, device, pid)
        else
          c
        end

    d = a + b + c
    Agent.update(pid, fn state -> Map.put(state, "#{source}", d) end)
    d
  end
end
