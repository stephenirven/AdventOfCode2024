defmodule Maps.CoordMap do
  def create_coord_map(data) do
    data
    |> String.split(["\n", "\r", "\r\n"])
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {line, row}, acc ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {codepoint, col}, acc ->
        Map.put(acc, {row, col}, codepoint)
      end)
    end)
  end
end
