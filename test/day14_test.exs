defmodule Day14Test do
  use ExUnit.Case

  test "memory contents are returned" do
    program = [
      "mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X",
      "mem[8] = 11",
      "mem[7] = 101",
      "mem[8] = 0"
    ]

    assert %{7 => 101, 8 => 64} == DockingDecoder.memory(program)
  end

  test "(floating-bit) memory contents are returned" do
    program = [
      "mask = 000000000000000000000000000000X1001X",
      "mem[42] = 100",
      "mask = 00000000000000000000000000000000X0XX",
      "mem[26] = 1"
    ]

    assert %{26 => 1,
             27 => 1,
             58 => 100,
             59 => 100,
             16 => 1,
             17 => 1,
             18 => 1,
             19 => 1,
             24 => 1,
             25 => 1} == DockingDecoder.memory_v2(program)
  end
end
