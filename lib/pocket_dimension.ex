defmodule PocketDimension do
  @active "#"

  def active_hypercubes(initial_state, n, space_size) do
    [Enum.map(initial_state, &String.codepoints/1)]
    |> wrap_hyperdimension(space_size)
    |> find_active_hypercubes()
    |> next_generation(1, n)
    |> Map.keys()
    |> Enum.count()
  end

  def active_cubes(initial_state, n, space_size) do
    [Enum.map(initial_state, &String.codepoints/1)]
    |> wrap_dimension(space_size)
    |> find_active_cubes()
    |> next_generation(1, n)
    |> Map.keys()
    |> Enum.count()
  end

  defp neighboring_cubes({x, y, z, w}) do
    [
      {x-1,y-1,z-1,w-1}, {x,y-1,z-1,w-1}, {x+1,y-1,z-1,w-1},
      {x-1,y,z-1,w-1}, {x,y,z-1,w-1}, {x+1,y,z-1,w-1},
      {x-1,y+1,z-1,w-1}, {x,y+1,z-1,w-1}, {x+1,y+1,z-1,w-1},
      {x-1,y-1,z+1,w-1}, {x,y-1,z+1,w-1}, {x+1,y-1,z+1,w-1},
      {x-1,y,z+1,w-1}, {x,y,z+1,w-1}, {x+1,y,z+1,w-1},
      {x-1,y+1,z+1,w-1}, {x,y+1,z+1,w-1}, {x+1,y+1,z+1,w-1},
      {x-1,y-1,z,w-1}, {x,y-1,z,w-1}, {x+1,y-1,z,w-1},
      {x-1,y+1,z,w-1}, {x,y+1,z,w-1}, {x+1,y+1,z,w-1},
      {x-1,y,z,w-1},
      {x+1,y,z,w-1},
      {x-1,y-1,z-1,w}, {x,y-1,z-1,w}, {x+1,y-1,z-1,w},
      {x-1,y,z-1,w}, {x,y,z-1,w}, {x+1,y,z-1,w},
      {x-1,y+1,z-1,w}, {x,y+1,z-1,w}, {x+1,y+1,z-1,w},
      {x-1,y-1,z+1,w}, {x,y-1,z+1,w}, {x+1,y-1,z+1,w},
      {x-1,y,z+1,w}, {x,y,z+1,w}, {x+1,y,z+1,w},
      {x-1,y+1,z+1,w}, {x,y+1,z+1,w}, {x+1,y+1,z+1,w},
      {x-1,y-1,z,w}, {x,y-1,z,w}, {x+1,y-1,z,w},
      {x-1,y+1,z,w}, {x,y+1,z,w}, {x+1,y+1,z,w},
      {x-1,y,z,w},
      {x+1,y,z,w},
      {x-1,y-1,z-1,w+1}, {x,y-1,z-1,w+1}, {x+1,y-1,z-1,w+1},
      {x-1,y,z-1,w+1}, {x,y,z-1,w+1}, {x+1,y,z-1,w+1},
      {x-1,y+1,z-1,w+1}, {x,y+1,z-1,w+1}, {x+1,y+1,z-1,w+1},
      {x-1,y-1,z+1,w+1}, {x,y-1,z+1,w+1}, {x+1,y-1,z+1,w+1},
      {x-1,y,z+1,w+1}, {x,y,z+1,w+1}, {x+1,y,z+1,w+1},
      {x-1,y+1,z+1,w+1}, {x,y+1,z+1,w+1}, {x+1,y+1,z+1,w+1},
      {x-1,y-1,z,w+1}, {x,y-1,z,w+1}, {x+1,y-1,z,w+1},
      {x-1,y+1,z,w+1}, {x,y+1,z,w+1}, {x+1,y+1,z,w+1},
      {x-1,y,z,w+1},
      {x+1,y,z,w+1},
      {x,y,z,w-1},
      {x,y,z,w+1}
    ]
  end

  defp neighboring_cubes({x, y, z}) do
    [
      {x-1,y-1,z-1}, {x,y-1,z-1}, {x+1,y-1,z-1},
      {x-1,y,z-1}, {x,y,z-1}, {x+1,y,z-1},
      {x-1,y+1,z-1}, {x,y+1,z-1}, {x+1,y+1,z-1},
      {x-1,y-1,z+1}, {x,y-1,z+1}, {x+1,y-1,z+1},
      {x-1,y,z+1}, {x,y,z+1}, {x+1,y,z+1},
      {x-1,y+1,z+1}, {x,y+1,z+1}, {x+1,y+1,z+1},
      {x-1,y-1,z}, {x,y-1,z}, {x+1,y-1,z},
      {x-1,y+1,z}, {x,y+1,z}, {x+1,y+1,z},
      {x-1,y,z},
      {x+1,y,z}
    ]
  end

  defp next_generation(active_cubes, gen, gen_n)
  when gen > gen_n, do: active_cubes
  defp next_generation(active_cubes, gen, gen_n) do
    affected_cubes =
      Enum.reduce(Map.to_list(active_cubes), %{}, fn {k, _v}, acc ->
        Enum.reduce(neighboring_cubes(k), acc, fn cube, n_acc ->
          Map.update(n_acc, cube, 1, &(&1 + 1))
        end)
      end)

    active_cubes =
      Enum.reduce(active_cubes, %{}, fn {k, _v}, acc ->
        n_of_k = neighboring_cubes(k)
        n_a_of_k = Enum.count(n_of_k, &(Map.has_key?(active_cubes, &1)))

        if n_a_of_k in 2..3 do
          Map.put(acc, k, 1)
        else
          acc
        end
      end)

    active_cubes =
      Enum.reduce(affected_cubes, active_cubes, fn {k, v}, acc ->
        if v == 3 do
          Map.put(acc, k, 1)
        else
          acc
        end
      end)

    next_generation(active_cubes, gen + 1, gen_n)
  end

  defp find_active_hypercubes(state) do
    state
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {w, w_i}, w_acc ->
      w
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {z, z_i}, z_acc ->
        z
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {y, y_i}, y_acc ->
          y
          |> Enum.with_index()
          |> Enum.reduce(%{}, fn {x, x_i}, x_acc ->
            if x == @active do
              Map.put(x_acc, {x_i, y_i, z_i, w_i}, 1)
            else
              x_acc
            end
          end)
          |> Map.merge(y_acc)
        end)
        |> Map.merge(z_acc)
      end)
      |> Map.merge(w_acc)
    end)
  end

  defp find_active_cubes(state) do
    state
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {z, z_i}, z_acc ->
      z
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {y, y_i}, y_acc ->
        y
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {x, x_i}, x_acc ->
          if x == @active do
            Map.put(x_acc, {x_i, y_i, z_i}, 1)
          else
            x_acc
          end
        end)
        |> Map.merge(y_acc)
      end)
      |> Map.merge(z_acc)
    end)
  end

  defp wrap_hyperdimension(state, size) do
    w_expansion =
      Stream.iterate(".", &(&1))
      |> Enum.take(size)
      |> Stream.iterate(&(&1))
      |> Enum.take(size)
      |> Stream.iterate(&(&1))
      |> Enum.take(size)

    [w_expansion] ++ [wrap_dimension(state, size)] ++ [w_expansion]
  end

  defp wrap_dimension(state, size) do
    z_expansion =
      Stream.iterate(".", &(&1))
      |> Enum.take(size)
      |> Stream.iterate(&(&1))
      |> Enum.take(size)

    [z_expansion] ++ state ++ [z_expansion]
  end
end
