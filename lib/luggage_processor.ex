defmodule LuggageProcessor do
  def number_of_contained_bags(rules, bag) do
    contained_bags_rec(rules, [{-1, bag}])
  end

  defp contained_bags_rec(_rules, [{0, nil}]), do: 0
  defp contained_bags_rec(rules, [{-1, bag}]) do
    -1 + contained_bags_rec(rules, [{1, bag}])
  end
  defp contained_bags_rec(rules, [{n, bag}]) do
    %{"bag_values" => bag_values} =
      rules
      |> Enum.find_value(fn r ->
        Regex.named_captures(~r/^#{bag}\ bags\ contain\ (?<bag_values>.*)\.$/, r)
      end)

    bag_quantities =
      bag_values
      |> String.split(", ")
      |> Enum.map(fn bag_str ->
        if bag_str == "no other bags" do
          {0, nil}
        else
          %{"count" => bag_count, "color" => bag_color} =
            Regex.named_captures(~r/(?<count>[1-9])\ (?<color>[a-z]+ [a-z]+)(?= bags?)/,
              bag_str)
          {String.to_integer(bag_count), bag_color}
        end
      end)

    n + n * contained_bags_rec(rules, bag_quantities)
  end
  defp contained_bags_rec(rules, [head | tail]) do
    contained_bags_rec(rules, [head]) + contained_bags_rec(rules, tail)
  end

  def bags_containing(rules, bag) do
    containing_bags_rec(rules, [bag])
    |> Enum.uniq()
  end

  defp containing_bags_rec(_rules, []), do: []
  defp containing_bags_rec(rules, [bag]) do
    bags_containing_bag =
      rules
      |> Enum.map(&(containing_bag(&1, bag)))
      |> Enum.filter(fn containing_bag -> is_binary(containing_bag) end)

    bags_containing_bag ++ containing_bags_rec(rules, bags_containing_bag)
  end
  defp containing_bags_rec(rules, [bag | other_bags]) do
    containing_bags_rec(rules, [bag]) ++ containing_bags_rec(rules, other_bags)
  end

  defp containing_bag(rule, bag) do
    containing_bag = ~r/^(?<color>[a-z]+ [a-z]+)\ bags\ contain\ .*(?<size>\d{1})\ #{bag}.*\.$/

    case Regex.named_captures(containing_bag, rule) do
      %{"color" => containing_bag_color,
        "size" => _containing_bag_size} ->
        containing_bag_color
      _ ->
        nil
    end
  end
end
