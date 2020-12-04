defmodule Day2Test do
  use ExUnit.Case

  test "number of invalid passwords are found" do
    passwords_with_policies = [
      "1-3 a: abcde",
      "1-3 b: cdefg",
      "2-9 c: ccccccccc"
    ]
    valid_passwords = PasswordManager.valid_passwords(passwords_with_policies)
    assert Enum.count(valid_passwords) == 2
  end

  test "number of valid 'toboggan' passwords are found" do
    passwords_with_policies = [
      "1-3 a: abcde",
      "1-3 b: cdefg",
      "2-9 c: ccccccccc"
    ]
    valid_passwords =
      PasswordManager.valid_toboggan_passwords(passwords_with_policies)
    assert Enum.count(valid_passwords) == 1
  end
end
