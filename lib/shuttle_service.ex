defmodule ShuttleService do
  def next_bus(earliest, schedule) do
    Stream.iterate(earliest, &(&1 + 1))
    |> Enum.reduce_while(0, fn time, _bus ->
      bus =
        schedule
        |> Enum.sort()
        |> Enum.find(fn b -> Integer.mod(time, b) == 0 end)
      if bus, do: {:halt, {time, bus}}, else: {:cont, 0}
    end)
  end

  def earliest_fleet(schedule) do
    schedule
    |> String.split(",")
    |> Enum.with_index()
    |> Enum.reject(&(elem(&1, 0) == "x"))
    |> Enum.map(fn {x, i} -> {String.to_integer(x), i} end)
    |> chinese_remainder_theorem()
  end

  defp chinese_remainder_theorem_rec([], _, sum), do: sum
  defp chinese_remainder_theorem_rec([{a, n} | rest], product, sum) do
    product_except_n = Integer.floor_div(product, n)

    {_x, y} = bezouts_coefficients(n, product_except_n)

    chinese_remainder_theorem_rec(rest, product, sum + a * y * product_except_n)
  end
  defp chinese_remainder_theorem(n_with_offset) do
    a = Enum.map(n_with_offset, &(elem(&1, 0) - elem(&1, 1)))
    n = Enum.unzip(n_with_offset) |> elem(0)

    a_n = Enum.zip(a, n)
    product_n = Enum.reduce(n, 1, &(&1 * &2))

    Integer.mod(chinese_remainder_theorem_rec(a_n, product_n, 0), product_n)
  end

  defp bezouts_coefficients_rec(_, r, sp, _, tp, _) when r == 0, do: {sp, tp}
  defp bezouts_coefficients_rec(rp, r, sp, s, tp, t) do
    q = Integer.floor_div(rp, r)
    bezouts_coefficients_rec(r, rp - q * r, s, sp - q * s, t, tp - q * t)
  end

  defp bezouts_coefficients(a, b) do
    # extended euclidean algorithm
    bezouts_coefficients_rec(a, b, 1, 0, 0, 1)
  end
end
