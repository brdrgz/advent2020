defmodule TobogganMap do
  def find_trees(map) do
    map
    |> Enum.with_index()
    |> Enum.map(fn {treeline, y} ->
      if y == 0
      || String.at(treeline, Integer.mod(y*3,
            String.length(treeline))) == "." do
        nil
      else
        {Integer.mod(y*3, String.length(treeline)), y}
      end
    end)
    |> Enum.filter(fn mark -> is_tuple(mark) end)
  end

  def find_trees_given_slope(map, {x, y}) do
    map
    |> Enum.with_index()
    |> Enum.filter(fn {_, i} -> Integer.mod(i, y) == 0 end)
    |> Enum.map_reduce(0, fn {treeline, i}, marker_pos ->
      if i == 0
      || String.at(treeline, Integer.mod(marker_pos,
            String.length(treeline))) == "." do
        {
          nil,
          Integer.mod(marker_pos + x, String.length(treeline))
        }
      else
        {
          {Integer.mod(marker_pos + x, String.length(treeline)), i},
          Integer.mod(marker_pos + x, String.length(treeline))
        }
      end
    end)
    |> Tuple.to_list()
    |> hd()
    |> Enum.filter(fn mark -> is_tuple(mark) end)
  end
end
