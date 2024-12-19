defmodule Maps.StringMap do
  # map of strings

  def set_char(map, {row, col}, character) do
    {bef, aft} = String.split_at(map[row], col)

    {_f, aft} = String.split_at(aft, 1)

    new_line = bef <> character <> aft

    Map.put(map, row, new_line)
  end

  def in_string_map(map, {row, col}) do
    cond do
      row < 0 or row >= map_size(map) or col < 0 or col >= String.length(map[0]) -> false
      true -> true
    end
  end
end
