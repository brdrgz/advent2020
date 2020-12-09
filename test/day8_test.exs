defmodule Day8Test do
  use ExUnit.Case

  test "cycle is detected and accumulator value is returned" do
    instructions = [
      "nop +0",
      "acc +1",
      "jmp +4",
      "acc +3",
      "jmp -3",
      "acc -99",
      "acc +1",
      "jmp -4",
      "acc +6"
    ]

    assert {:cycle, 5} = BootCode.execute_to_cycle(instructions)
  end

  test "program runs to completion and accumulator value is returned" do
    instructions = [
      "nop +0",
      "acc +1",
      "jmp +4",
      "acc +3",
      "jmp -3",
      "acc -99",
      "acc +1",
      "nop -4",
      "acc +6"
    ]

    assert {:done, 8} = BootCode.execute_to_completion(instructions)
  end
end
