defmodule InputLoader do
  def load_expense_report(path) do
    File.read!(path)
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  def load_passwords_and_policies(path) do
    File.read!(path)
    |> String.split("\n")
  end
end
