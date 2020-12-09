defmodule BootCode do
  def execute_to_cycle(instructions) do
    assembled_instructions =
      instructions
      |> Enum.map(fn ins ->
        <<op::binary-size(3), " ", arg::binary>> = ins
        %{op: op, arg: String.trim(arg), x: false}
      end)

    process_instructions_until_cycle(assembled_instructions)
  end

  def execute_to_completion(instructions) do
    assembled_instructions =
      instructions
      |> Enum.map(fn ins ->
        <<op::binary-size(3), " ", arg::binary>> = ins
        %{op: op, arg: String.trim(arg)}
      end)

    process_instructions(assembled_instructions)
  end

  defp process_instructions(instructions) do
    process_instructions_rec(instructions, 0, 0)
  end

  defp process_instructions_rec(instructions, pc, acc) do
    {curr_ins, _} = List.pop_at(instructions, pc)

    if is_nil(curr_ins) do
      {:done, acc}
    else
      case curr_ins[:op] do
        "nop" ->
          process_instructions_rec(instructions, pc + 1, acc)
        "acc" ->
          acc = add_signed_binary(acc, curr_ins[:arg])
          process_instructions_rec(instructions, pc + 1, acc)
        "jmp" ->
          pc = add_signed_binary(pc, curr_ins[:arg])
          process_instructions_rec(instructions, pc, acc)
      end
    end
  end

  defp process_instructions_until_cycle(instructions) do
    process_instructions_until_cycle_rec(instructions, 0, 0)
  end

  defp process_instructions_until_cycle_rec(instructions, pc, acc) do
    {curr_ins, _} = List.pop_at(instructions, pc)

    if already_processed?(curr_ins) do
      {:cycle, acc}
    else
      instructions = List.update_at(instructions, pc, &(%{&1 | x: true}))
      case curr_ins[:op] do
        "nop" ->
          process_instructions_until_cycle_rec(instructions, pc + 1, acc)
        "acc" ->
          acc = add_signed_binary(acc, curr_ins[:arg])
          process_instructions_until_cycle_rec(instructions, pc + 1, acc)
        "jmp" ->
          pc = add_signed_binary(pc, curr_ins[:arg])
          process_instructions_until_cycle_rec(instructions, pc, acc)
      end
    end
  end

  defp already_processed?(instruction) do
    instruction[:x]
  end

  defp add_signed_binary(value, signed_value_as_binary) do
    case signed_value_as_binary do
      <<"+", positive_value::binary>> ->
        value + String.to_integer(positive_value)
      <<"-", positive_value::binary>> ->
        value + -1 * String.to_integer(positive_value)
    end
  end
end
