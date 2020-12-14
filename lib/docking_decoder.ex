defmodule DockingDecoder do
  def memory(init_program) do
    initial_mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    execute_statement(%{}, initial_mask, init_program)
  end

  def memory_v2(init_program) do
    initial_mask = "000000000000000000000000000000000000"
    execute_statement_v2(%{}, initial_mask, init_program)
  end

  defp execute_statement_v2(mem, _mask, []), do: mem
  defp execute_statement_v2(mem, mask, [line | rest]) do
    [var, val] = String.split(line, " = ")
    case var do
      "mask" -> execute_statement_v2(mem, val, rest)
      <<"mem[", _::binary>> ->
        %{"i" => i} =
          Regex.named_captures(~r/mem\[(?<i>(0|[1-9]{1}[0-9]*))\]/, var)
        keys = String.to_integer(i) |> apply_mask_v2(mask)
        v = String.to_integer(val)
        mem = keys |> Enum.reduce(mem, &(Map.put(&2, &1, v)))
        execute_statement_v2(mem, mask, rest)
    end
  end

  defp expand_mask_rec(mask) do
    parts = String.split(mask, "X", parts: 2)

    case Enum.count(parts) do
      1 -> [mask]
      2 ->
        left = Enum.at(parts, 0)
        right = Enum.at(parts, 1)
        expand_mask_rec(Enum.join([left, "0", right])) ++
          expand_mask_rec(Enum.join([left, "1", right]))
    end
  end

  defp expand_mask(mask) do
    expand_mask_rec(mask)
  end

  defp apply_mask_v2(value, mask) do
    value
    |> integer_to_binary_bitstring()
    |> String.codepoints()
    |> Enum.map_reduce(mask, fn bit, mask ->
      <<mask_bit::binary-size(1), rest_of_mask::binary>> = mask
      new_bit = case mask_bit do
                  "0" -> bit
                  _ -> mask_bit
                end
      {new_bit, rest_of_mask}
    end)
    |> elem(0)
    |> Enum.join()
    |> expand_mask()
    |> Enum.map(&(String.to_integer(&1, 2)))
  end

  defp execute_statement(mem, _mask, []), do: mem
  defp execute_statement(mem, mask, [line | rest]) do
    [var, val] = String.split(line, " = ")
    case var do
      "mask" -> execute_statement(mem, val, rest)
      <<"mem[", _::binary>> ->
        %{"i" => i} =
          Regex.named_captures(~r/mem\[(?<i>(0|[1-9]{1}[0-9]*))\]/, var)
        k = String.to_integer(i)
        v = String.to_integer(val) |> apply_mask(mask)
        execute_statement(Map.put(mem, k, v), mask, rest)
    end
  end

  defp apply_mask(value, mask) do
    value
    |> integer_to_binary_bitstring()
    |> String.codepoints()
    |> Enum.map_reduce(mask, fn bit, mask ->
      <<mask_bit::binary-size(1), rest_of_mask::binary>> = mask
      new_bit = case mask_bit do
                  "X" -> bit
                  _ -> mask_bit
                end
      {new_bit, rest_of_mask}
    end)
    |> elem(0)
    |> Enum.join()
    |> binary_bitstring_to_integer()
  end

  defp binary_bitstring_to_integer(bitstring) do
    bitstring
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
    |> Integer.undigits(2)
  end

  defp integer_to_binary_bitstring(integer) do
    integer
    |> Integer.to_string(2)
    |> String.pad_leading(36, "0")
  end
end
