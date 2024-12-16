defmodule Data do
  # Read in data
  def read(number) do
    Path.expand("../inputs/#{number}.txt", __DIR__)
    |> File.read!()
  end

  # Map of codepoints

  def create_map(data) do
    data
    |> String.split(["\n", "\r", "\r\n"])
    |> Enum.map(fn line ->
      String.codepoints(line)
      |> Enum.with_index()
      |> Enum.map(fn {v, k} -> {k, v} end)
      |> Map.new()
    end)
    |> Enum.with_index()
    |> Enum.map(fn {v, k} -> {k, v} end)
    |> Map.new()
  end

  def set_value(map, {r, c}, value) do
    Map.update(map, r, %{}, fn existing ->
      Map.put(existing, c, value)
    end)
  end

  def in_map(map, {r, c}) do
    cond do
      r >= 0 and r < map_size(map) and c >= 0 and c < map_size(map[r]) -> true
      true -> false
    end
  end

  def get_value(map, {row, col}) do
    cond do
      row < 0 -> false
      row >= map_size(map) -> false
      col < 0 -> false
      col >= map_size(map[0]) -> false
      true -> map[row][col]
    end
  end

  def find_value(map, symbol) do
    Enum.reduce(map, [], fn {row, line}, acc ->
      line
      |> Enum.reduce(acc, fn {col, char}, acc ->
        if char == symbol do
          [{row, col} | acc]
        else
          acc
        end
      end)
    end)
  end

  def find_values(map, symbols) do
    Enum.reduce(map, [], fn {row, line}, acc ->
      line
      |> Enum.reduce(acc, fn {col, char}, acc ->
        if char in symbols do
          [{row, col} | acc]
        else
          acc
        end
      end)
    end)
  end

  # Map of coords to characters

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

  # map of strings

  def set_char(map, {row, col}, character) do
    {bef, aft} = String.split_at(map[row], col)

    {_f, aft} = String.split_at(aft, 1)

    new_line = bef <> character <> aft

    Map.put(map, row, new_line)
  end

  def get_adjacent(map, {r, c}) do
    [
      {r - 1, c},
      {r, c + 1},
      {r + 1, c},
      {r, c - 1}
    ]
    |> Enum.filter(fn coord ->
      in_map(map, coord)
    end)
    |> Enum.filter(fn {adj_r, adj_c} ->
      map[adj_r][adj_c] == map[r][c] + 1
    end)
  end


  def get_adjacent_same(map, {r, c}) do
    [
      {r - 1, c},
      {r, c + 1},
      {r + 1, c},
      {r, c - 1}
    ]
    |> Enum.filter(fn coord ->
      in_map(map, coord)
    end)
    |> Enum.filter(fn {adj_r, adj_c} ->
      map[adj_r][adj_c] == map[r][c]
    end)
  end

  def in_string_map(map, {row, col}) do
    cond do
      row < 0 or row >= map_size(map) or col < 0 or col >= String.length(map[0]) -> false
      true -> true
    end
  end
end
