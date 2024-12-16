defmodule December15 do
  import Data

  @empty_character "."
  @wall_character "#"


  # Day 15 - Part 1 solution
  def part1 do
    {map, robot, moves} = read(15) |> get_problem()

    {_res, _robot, map} =
      Enum.reduce(moves, {:ok, robot, map}, fn move, {_res, robot, map} ->
        move_object(map, robot, move)
      end)

    visualise_map(map)
    coordinates = get_coordinates(map)

    IO.puts("The sum of the boxes coordinates is #{coordinates}")
  end

  # Day 15 - part 2 solution

  def part2 do

    doubled = true
    {map, robot, moves} = read(15) |> get_problem(doubled)

    {_res, _robot, map} =
      Enum.reduce(moves, {:ok, robot, map}, fn move, {_res, robot, map} ->
        move_object(map, robot, move)
      end)

    visualise_map(map)
    coordinates = get_coordinates(map)

    IO.puts("The sum of the boxes coordinates is #{coordinates}")
  end

  ##### Process the input #####

  def get_problem(data, doubled \\ false) do
    [map_section, move_section] = String.split(data, "\n\n")

    map =
      case doubled do
        false -> create_map(map_section)
        true -> create_doubled_map(map_section)
      end

    # find_coords(map, "@")
    robot = hd(find_value(map, "@"))

    moves =
      move_section
      |> String.codepoints()
      |> Enum.filter(fn char ->
        char in ["v", ">", "^", "<"]
      end)

    {map, robot, moves}
  end

  def create_doubled_map(data) do
    data
    |> String.split(["\n", "\r", "\r\n"])
    |> Enum.map(fn line ->
      String.codepoints(line)
      |> Enum.map(fn codepoint ->
        cond do
          codepoint == "#" -> ["#", "#"]
          codepoint == "O" -> ["[", "]"]
          codepoint == "." -> [".", "."]
          codepoint == "@" -> ["@", "."]
        end
      end)
      |> List.flatten()
      |> Enum.with_index()
      |> Enum.map(fn {v, k} -> {k, v} end)
      |> Map.new()
    end)
    |> Enum.with_index()
    |> Enum.map(fn {v, k} -> {k, v} end)
    |> Map.new()
  end

  ##### Map output for verification #####

  def visualise_map(map) do
    Enum.map(map |> Enum.sort(fn {row, _}, {row2, _} -> row < row2 end), fn {_row, line} ->
      line
      |> Enum.sort(fn {col, _}, {col2, _} -> col < col2 end)
      |> Enum.map(fn {_col, char} -> char end)
      |> Enum.join()
      |> IO.puts()
    end)
  end

  ##### Move an object on the map, returning the status, new coordinates and new map #####
  def move_object(map, {r, c}, move, trigger \\ true, replace \\ @empty_character) do
    current = get_value(map, {r, c})

    next_coord =
      case move do
        "^" -> {r - 1, c}
        ">" -> {r, c + 1}
        "v" -> {r + 1, c}
        "<" -> {r, c - 1}
      end

    cond do
      r >= map_size(map) or r <= 0 or c < 0 or c >= map_size(map[0]) ->
        {:error, {r, c}, map}

      current == @wall_character ->
        {:error, {r, c}, map}

      current == @empty_character ->
        {:ok, next_coord, set_value(map, {r, c}, replace)}

      trigger and current == "[" and (move == "^" or move == "v") ->
        move_objects(map, {{r, c}, {r, c + 1}}, move, {replace, @empty_character})

      trigger and current == "]" and (move == "^" or move == "v") ->
        move_objects(map, {{r, c}, {r, c - 1}}, move, {replace, @empty_character})

      true ->
        res = move_object(map, next_coord, move, true, current)

        case res do
          {:error, _coords, map} ->
            {:error, {r, c}, map}

          {:ok, _coords, map} ->
            {:ok, next_coord, set_value(map, {r, c}, replace)}
        end
    end
  end

  ##### Move two objects on the map as above #####

  def move_objects(
        map,
        {one, two},
        move,
        {replace1, replace2} \\ {@empty_character, @empty_character}
      ) do
    {res2, _, new_map} = move_object(map, two, move, false, replace2)
    updated_result = {res1, _, _} = move_object(new_map, one, move, false, replace1)

    if res1 == :ok and res2 == :ok do
      updated_result
    else
      {:error, one, map}
    end
  end

  ##### Get coordinates for the box symbols on the map #####

  def get_coordinates(map) do
    find_values(map, ["O", "["])
    |> Enum.map(fn {r, c} ->
      100 * r + c
    end)
    |> Enum.sum()
  end

end
