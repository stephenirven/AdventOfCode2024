defmodule December18 do
  import Maps.CodepointMap
  import Data

  ##### Day 18 part 1 - https://adventofcode.com/2024/day/18 #####

  def part1 do
    drops =
      read("18")
      |> get_drops()

    grid = get_grid(71, 71)

    grid = process_drops(grid, drops, 1024)
    visualise_map(grid)
    route = solve(grid, {0, 0}, {70, 70})

    route_map =
      Enum.reduce(route, grid, fn coord, grid ->
        set_value(grid, coord, "O")
      end)

    visualise_map(route_map)
    IO.puts("Length of route through maze is #{length(route) - 1}")
  end

  ##### Day 18 - part 2 - https://adventofcode.com/2024/day/18#part2 #####

  def part2 do
    grid = get_grid(71, 71)

    drops = read("18") |> String.trim() |> get_drops()

    minimal = get_minimal_fail(grid, drops, 0, length(drops) - 1, length(drops) - 1)

    drops = Enum.drop(drops, minimal - 1)
    coord = hd(drops)

    IO.puts("The coordinate of the first memory drop that blocks the route is #{inspect(coord)}")
  end

  ##### Get ine incoming list of drops into the memory space #####

  def get_drops(data) do
    data
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.split(line, ",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  ##### Generate the blank memory grid #####

  def get_grid(max_y, max_x) do
    for y <- 0..(max_y - 1) do
      {String.duplicate(".", max_x)
       |> String.codepoints()
       |> Enum.with_index()
       |> Enum.map(fn {v, k} -> {k, v} end)
       |> Map.new(), y}
    end
    |> Enum.map(fn {v, k} -> {k, v} end)
    |> Map.new()
  end

  ##### Generate the map after {number} of drops into the memory space #####

  def process_drops(grid, drops, number) do
    drops_to_process = Enum.take(drops, number)

    Enum.reduce(drops_to_process, grid, fn {x, y}, grid ->
      set_value(grid, {y, x}, "#")
    end)
  end

  ##### Solve the map #####

  def solve(grid, current, destination) do
    queue = :queue.new()
    queue = :queue.in([current], queue)
    solve_bfs(grid, destination, queue)
  end

  ##### Breadth first search maze solver #####

  def solve_bfs(
        grid,
        destination,
        queue \\ :queue.new(),
        seen \\ MapSet.new()
      ) do
    if :queue.len(queue) == 0 do
      :error
    else
      {{_val, path}, queue} = :queue.out(queue)

      node = hd(path)

      cond do
        MapSet.member?(seen, node) ->
          solve_bfs(grid, destination, queue, seen)

        node == destination ->
          Enum.reverse(path)

        true ->
          seen = MapSet.put(seen, node)

          adjacent =
            get_adjacent(grid, node)
            |> Enum.filter(fn {r, c} = coord ->
              !MapSet.member?(seen, coord) and grid[r][c] != "#"
            end)

          queue =
            Enum.reduce(adjacent, queue, fn node, queue ->
              new_path = [node | path]

              :queue.in(new_path, queue)
            end)

          solve_bfs(grid, destination, queue, seen)
      end
    end
  end

  ##### Binary search for maximal number of drops that lead to a routable maze #####

  def get_minimal_fail(_grid, _drops, min, max, lowest_fail \\ 0)

  def get_minimal_fail(_grid, _drops, min, max, lowest_fail) when max < min do
    lowest_fail
  end

  def get_minimal_fail(grid, drops, min, max, lowest_fail) do
    current = trunc((max - min) / 2) + min

    updated_grid = process_drops(grid, drops, current)

    result = solve(updated_grid, {0, 0}, {70, 70})

    case result do
      :error ->
        get_minimal_fail(grid, drops, min, current - 1, current)

      _ ->
        get_minimal_fail(grid, drops, current + 1, max, lowest_fail)
    end
  end
end
