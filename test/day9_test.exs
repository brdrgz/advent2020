defmodule Day9Test do
  use ExUnit.Case

  test "first number which is not sum of two previous numbers is found" do
    data = [
      35,
      20,
      15,
      25,
      47,
      40,
      62,
      55,
      65,
      95,
      102,
      117,
      150,
      182,
      127,
      219,
      299,
      277,
      309,
      576
    ]

    assert {:invalid, 127} = XMASDecoder.decode(data, preamble_length: 5)
  end

  test "sum of first and last in contiguous set of summands" <>
    " of 'invalid' number is found" do
    data = [
      35,
      20,
      15,
      25,
      47,
      40,
      62,
      55,
      65,
      95,
      102,
      117,
      150,
      182,
      127,
      219,
      299,
      277,
      309,
      576
    ]

    assert (15 + 47) == XMASDecoder.exploit_iv(data, preamble_length: 5)
  end
end
