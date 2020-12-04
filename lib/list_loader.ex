defmodule ListLoader do
  def load_from_file(path) do
    File.read!(path)
    |> String.split()
  end
end
