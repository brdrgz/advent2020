defmodule PassportScanner do
  def valid_passports(passports) do
    fields = [
      %{name: "byr", required?: true},
      %{name: "iyr", required?: true},
      %{name: "eyr", required?: true},
      %{name: "hgt", required?: true},
      %{name: "hcl", required?: true},
      %{name: "ecl", required?: true},
      %{name: "pid", required?: true},
      %{name: "cid", required?: false}
    ]

    passports
    |> Enum.map(fn passport ->
      required_fields_present? = fields
      |> Enum.filter(fn field -> field.required? end)
      |> Enum.all?(fn field -> String.contains?(passport, "#{field.name}:") end)

      if required_fields_present? do
        passport
      else
        nil
      end
    end)
    |> Enum.filter(fn passport -> is_binary(passport) end)
  end

  def valid_passports_with_valid_data(passports) do
    fields = [
      %{name: "byr",
        required?: true,
        valid?: (fn v ->
          Enum.member?(1920..2002, String.to_integer(v))
        end)},
      %{name: "iyr",
        required?: true,
        valid?: (fn v ->
          Enum.member?(2010..2020, String.to_integer(v))
        end)},
      %{name: "eyr",
        required?: true,
        valid?: (fn v ->
          Enum.member?(2020..2030, String.to_integer(v))
        end)},
      %{name: "hgt",
        required?: true,
        valid?: (fn v ->
          cm_in_pattern = ~r/(?<cv>^[1-9][0-9][0-9]cm$)|(?<iv>^[1-9][0-9]in$)/
          case Regex.named_captures(cm_in_pattern, v) do
            %{"cv" => <<cm_value::binary-size(3), "cm">>, "iv" => ""} ->
              150..193
              |> Enum.member?(String.to_integer(cm_value))
            %{"cv" => "", "iv" => <<in_value::binary-size(2), "in">>} ->
              59..76
              |> Enum.member?(String.to_integer(in_value))
            _ -> false
          end
        end)},
      %{name: "hcl",
        required?: true,
        valid?: (fn v ->
          case v do
            <<"#", hex_color::binary-size(6)>> ->
              String.match?(hex_color, ~r/^[0-9a-f]{6}$/)
            _ -> false
          end
        end)},
      %{name: "ecl",
        required?: true,
        valid?: (fn v ->
          ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
          |> Enum.member?(v)
        end)},
      %{name: "pid",
        required?: true,
        valid?: (fn v ->
          String.match?(v, ~r/^[0-9]{9}$/)
        end)},
      %{name: "cid",
        required?: false,
        valid?: (fn _v ->
          true
        end)}
    ]

    passports
    |> Enum.map(fn passport ->
      required_fields_present_and_valid? = fields
      |> Enum.filter(fn field -> field.required? end)
      |> Enum.all?(fn field ->
        field_value_pattern = ~r/#{field.name}:(?<value>[^[:space:]]+)/
        case Regex.named_captures(field_value_pattern, passport) do
          %{"value" => value} -> field.valid?.(value)
          _ -> false
        end
      end)

      if required_fields_present_and_valid? do
        passport
      else
        nil
      end
    end)
    |> Enum.filter(fn passport -> is_binary(passport) end)
  end
end
