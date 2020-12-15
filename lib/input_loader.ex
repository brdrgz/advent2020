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

  def load_map(path) do
    File.read!(path)
    |> String.split("\n")
  end

  def load_passports(path) do
    File.read!(path)
    |> String.split("\n\n")
  end

  def load_boarding_passes(path) do
    File.read!(path)
    |> String.split()
  end

  def load_customs_forms(path) do
    File.read!(path)
    |> String.split("\n\n")
  end

  def load_luggage_rules(path) do
    File.read!(path)
    |> String.split("\n")
  end

  def load_boot_code(path) do
    File.read!(path)
    |> String.split("\n")
  end

  def load_xmas_data(path) do
    File.read!(path)
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def load_adapter_bag(path) do
    File.read!(path)
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def load_seat_map(path) do
    File.read!(path)
    |> String.split("\n")
  end

  def load_navigation_instructions(path) do
    File.read!(path)
    |> String.split("\n")
  end

  def load_time_and_bus_schedule(path) do
    {earliest, schedule} =
      File.read!(path)
      |> String.split("\n")
      |> List.to_tuple()

    {String.to_integer(earliest),
     String.split(schedule, ",")
     |> Enum.reject(&(&1 == "x"))
     |> Enum.map(&String.to_integer/1)}
  end

  def load_bus_schedule(path) do
    File.read!(path)
    |> String.split("\n")
    |> List.to_tuple()
    |> elem(1)
  end

  def load_initialization_program(path) do
    File.read!(path)
    |> String.split("\n")
  end

  def load_memory_game_numbers(path) do
    File.read!(path)
    |> String.split(",")
  end
end
