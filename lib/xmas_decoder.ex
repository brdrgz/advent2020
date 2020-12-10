defmodule XMASDecoder do
  def decode(data, preamble_length: preamble_length) do
    find_invalid(data, preamble_length)
  end

  def exploit_iv(data, preamble_length: preamble_length) do
    {:invalid, n} = find_invalid(data, preamble_length)

    summands =
      data
      |> Enum.slice(0..index_of_value(data, n)-1)
      |> find_contiguous_summands(n)
      |> Enum.sort()

    List.first(summands) + List.last(summands)
  end

  defp find_invalid(data, preamble_length) do
    find_invalid_rec(data, Enum.count(data), 0, preamble_length - 1)
  end

  defp find_invalid_rec(_, max, _, r) when r == max, do: {:not_found, nil}
  defp find_invalid_rec(data, max, l, r) do
    n = data
      |> Enum.at(r + 1)
    parts = data
      |> Enum.slice(l, r)
      |> Enum.sort(&>=/2)
      |> Enum.reject(&(&1 >= n))
    if sum_of_parts(n, parts) do
      find_invalid_rec(data, max, l + 1, r + 1)
    else
      {:invalid, n}
    end
  end

  defp sum_of_parts(_, []), do: false
  defp sum_of_parts(n, parts) do
    if contains_summands?(parts, n) do
      true
    else
      sum_of_parts(n, tl(parts))
    end
  end

  defp contains_summands?(list, n) do
    {a, rest} = List.pop_at(list, 0)
    Enum.any?(rest, fn b -> n - a - b == 0 end)
  end

  defp index_of_value(list, n) do
    list
    |> Enum.find_index(&(&1 == n))
  end

  defp find_contiguous_summands(list, n) do
    {a, b} = find_contiguous_summands_rec(list, n, 0)
    Enum.slice(list, a..b)
  end

  defp find_contiguous_summands_rec([_], _, _), do: {0, 0}
  defp find_contiguous_summands_rec(list, n, i) do
    {found, at} = contiguous_summands_found?(list, n)
    if found == :yes do
      {i, i + at}
    else
      find_contiguous_summands_rec(tl(list), n, i + 1)
    end
  end

  defp contiguous_summands_found?(list, n) do
    sum_and_index =
      list
      |> Enum.with_index()
      |> Enum.reduce_while({0, 0}, fn {x, i}, acc ->
        if elem(acc, 0) < n do
          {:cont, {elem(acc, 0) + x, i + 1}}
        else
          {:halt, {elem(acc, 0), i - 1}}
        end
      end)

    if elem(sum_and_index, 0) == n do
      {:yes, elem(sum_and_index, 1)}
    else
      {:no, nil}
    end
  end
end
