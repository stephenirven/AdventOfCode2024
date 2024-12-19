defmodule December10 do
  import Data
  import Maps.CodepointMap

  ##### Day 10 - Part 1 solution #####

  def part1(unique \\ false) do
    map =
      read("10")
      |> get_map()

    trailheads = get_trailheads(map)

    trails =
      Enum.map(trailheads, fn head ->
        get_trails(map, head, unique)
      end)

    IO.inspect(trails)

    scores = trails |> Enum.map(&Enum.count/1)

    IO.puts("The sum of trailhead scores is #{Enum.sum(scores)}")
  end

  ##### Day 10 - Part 2 solution

  def part2 do
    part1(true)
  end

  ##### Loading and processing data #####

  def get_map(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.codepoints(line)
      |> Enum.with_index()
      |> Enum.map(fn {v, k} ->
        {k,
         case v do
           n when n in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] -> String.to_integer(n)
           _ -> nil
         end}
      end)
      |> Map.new()
    end)
    |> Enum.with_index()
    |> Enum.map(fn {v, k} -> {k, v} end)
    |> Map.new()
  end

  def get_trailheads(map, starting_digit \\ 0) do
    Enum.reduce(map, [], fn {row, line}, acc ->
      acc ++
        (line
         |> Enum.filter(fn {_k, v} -> v == starting_digit end)
         |> Enum.map(fn {col, _c} ->
           {row, col}
         end))
    end)
  end

  ##### Get trails starting from the specified point #####

  def get_trails(map, position = {r, c}, allow_alternates \\ false, current_trail \\ []) do
    current = map[r][c]

    current_trail = [position | current_trail]

    cond do
      current == 9 ->
        position

      current == 0 and !allow_alternates ->
        get_adjacent(map, position)
        |> Enum.filter(fn {adj_r, adj_c} ->
          map[adj_r][adj_c] == map[r][c] + 1
        end)
        |> Enum.map(fn coord ->
          get_trails(map, coord, allow_alternates, current_trail)
        end)
        |> List.flatten()
        |> Enum.uniq()

      current == 0 ->
        get_adjacent(map, position)
        |> Enum.filter(fn {adj_r, adj_c} ->
          map[adj_r][adj_c] == map[r][c] + 1
        end)
        |> Enum.map(fn coord ->
          get_trails(map, coord, allow_alternates, current_trail)
        end)
        |> List.flatten()

      true ->
        get_adjacent(map, position)
        |> Enum.filter(fn {adj_r, adj_c} ->
          map[adj_r][adj_c] == map[r][c] + 1
        end)
        |> Enum.map(fn coord ->
          get_trails(map, coord, allow_alternates, current_trail)
        end)
    end
  end
end
