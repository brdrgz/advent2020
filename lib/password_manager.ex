defmodule PasswordManager do
  def valid_passwords(passwords_with_policies) do
    passwords_with_policies
    |> Enum.map(fn entry ->
      [occurrences,
       <<character::binary-size(1), ":">>,
       password] = String.split(entry)

      [min_occurrences,
       max_occurrences] = occurrences
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

      {min_occurrences,
       max_occurrences,
       character,
       password}
    end)
    |> Enum.filter(fn {min, max, c, pass} ->
      occurrences = Enum.count(String.codepoints(pass), fn x -> x == c end)
      occurrences >= min && occurrences <= max
    end)
  end

  def valid_toboggan_passwords(passwords_with_policies) do
    passwords_with_policies
    |> Enum.map(fn entry ->
      [valid_positions,
       <<character::binary-size(1), ":">>,
       password] = String.split(entry)

      [valid_position_a,
       valid_position_b] = valid_positions
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

      {valid_position_a,
       valid_position_b,
       character,
       password}
    end)
    |> Enum.filter(fn {pos_a, pos_b, c, pass} ->
      found_at_pos_a? = String.at(pass, pos_a-1) == c
      found_at_pos_b? = String.at(pass, pos_b-1) == c

      (found_at_pos_a? && !found_at_pos_b?)
      || (!found_at_pos_a? && found_at_pos_b?)
    end)
  end
end
