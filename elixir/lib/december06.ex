defmodule December06 do
  import Data
  import Maps.StringMap

  @directions %{
    0 => {{-1, 0}, "↑"},
    1 => {{0, 1}, "→"},
    2 => {{1, 0}, "↓"},
    3 => {{0, -1}, "←"}
  }

  ##### Day 6 - Part 1 solution #####

  def part1 do
    {map, position} =
      read("06")
      |> parse()

    {seen, moves} = seen_squares(map, position, 0)

    for line <- visualise(map, seen) do
      IO.puts(line)
    end

    IO.inspect(moves)

    count = map_size(seen)

    IO.puts("The number of visited squares is #{count}")
  end

  ##### Day 6 - Part 2 solution #####

  def part2 do
    {map, position} =
      read("06")
      |> parse()

    blocks = seen_squares_block(map, position, 0, map_size(map), String.length(map[0]))

    IO.puts("The number of possible blocks is #{map_size(blocks)}")
  end

  ##### Get a direction from the provided index #####

  def get_direction(index) do
    index = rem(index, 4)
    @directions[index]
  end

  ##### Get a display symbol for the direction index #####

  def get_direction_symbol(index) do
    {_direction, symbol} = get_direction(index)

    symbol
  end

  ##### Data loading and processing #####

  def parse(data) do
    map =
      data
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.map(fn {v, k} -> {k, v} end)
      |> Map.new()

    position =
      Enum.reduce(map, nil, fn {row, line}, acc ->
        match = :binary.match(line, "^")

        case match do
          {col, _len} ->
            {row, col}

          :nomatch ->
            acc
        end
      end)

    {map, position}
  end

  ##### Get a map of seen squares and a list of moves from the guard's route #####

  def seen_squares(map, position, direction) do
    seen_squares(map, position, direction, map_size(map), String.length(map[0]))
  end

  def seen_squares(
        map,
        position,
        direction \\ 0,
        max_rows,
        max_cols,
        seen \\ Map.new(),
        moves \\ []
      )

  def seen_squares(_map, {row, col}, _direction, max_rows, max_cols, seen, moves)
      when row < 0 or row >= max_rows or col < 0 or col >= max_cols,
      do: {seen, Enum.reverse(moves)}

  def seen_squares(map, {row, col} = position, direction_index, max_rows, max_cols, seen, moves) do
    direction_index = get_direction(map, position, direction_index)
    {{dir_row, dir_col}, _arrow} = @directions[direction_index]

    seen =
      Map.update(seen, position, MapSet.new([direction_index]), fn existing ->
        MapSet.put(existing, direction_index)
      end)

    moves = [{position, direction_index} | moves]
    next = {row + dir_row, col + dir_col}
    seen_squares(map, next, direction_index, max_rows, max_cols, seen, moves)
  end

  ##### Test blocks along the guard's route to determine how many possible blocking locations cause a loop #####

  def seen_squares_block(
        map,
        position,
        direction \\ 0,
        max_rows,
        max_cols,
        seen \\ Map.new(),
        moves \\ [],
        blocks \\ Map.new(),
        testing_block \\ nil
      )

  # currently testing a block and we left the map - no loop
  def seen_squares_block(
        _map,
        {row, col},
        _direction,
        max_rows,
        max_cols,
        _seen,
        _moves,
        _blocks,
        currently_testing
      )
      when (row < 0 or row >= max_rows or col < 0 or col >= max_cols) and currently_testing != nil,
      do: nil

  # not currently testing a block and we left the map - return list of blocks that caused a loop
  def seen_squares_block(
        _map,
        {row, col},
        _direction,
        max_rows,
        max_cols,
        _seen,
        _moves,
        blocks,
        _currently_testing
      )
      when row < 0 or row >= max_rows or col < 0 or col >= max_cols,
      do: blocks

  def seen_squares_block(
        map,
        {row, col} = position,
        direction_index,
        max_rows,
        max_cols,
        seen,
        moves,
        blocks,
        currently_testing
      ) do
    direction_index = get_direction(map, position, direction_index)
    {{dir_row, dir_col}, _arrow} = @directions[direction_index]

    # If we've been here before going in the same direction, it's a loop
    hits = Map.get(seen, position, MapSet.new())

    if MapSet.member?(hits, direction_index) do
      moves = [{position, direction_index} | moves]

      {position, Enum.reverse(moves)}
    else
      moves = [{position, direction_index} | moves]

      seen =
        Map.update(seen, position, MapSet.new(), fn existing ->
          MapSet.put(existing, direction_index)
        end)

      next_square = {row + dir_row, col + dir_col}

      blocks =
        test_block(
          map,
          position,
          direction_index,
          next_square,
          seen,
          moves,
          blocks,
          currently_testing
        )

      seen_squares_block(
        map,
        next_square,
        direction_index,
        max_rows,
        max_cols,
        seen,
        moves,
        blocks,
        currently_testing
      )
    end
  end

  # if we are currently testing a block, we can't add more
  def test_block(
        _map,
        _position,
        _direction_index,
        _next_square,
        _seen,
        _moves,
        blocks,
        currently_testing
      )
      when currently_testing != nil,
      do: blocks

  def test_block(
        map,
        {row, col} = position,
        direction_index,
        next_square,
        seen,
        moves,
        blocks,
        _currently_testing
      ) do
    cond do
      in_string_map(map, next_square) and !Map.has_key?(seen, next_square) ->
        new_block = next_square
        # IO.puts("testing block at #{inspect(new_block)}")

        new_map = set_char(map, new_block, "O")

        direction_index = get_direction(new_map, position, direction_index)
        {{dir_row, dir_col}, _arrow} = @directions[direction_index]

        next_square = {row + dir_row, col + dir_col}

        loop_detection_location =
          seen_squares_block(
            new_map,
            next_square,
            direction_index,
            map_size(map),
            String.length(map[0]),
            seen,
            moves,
            blocks,
            new_block
          )

        case loop_detection_location do
          nil ->
            blocks

          {_position, moves} ->
            Map.put(blocks, new_block, moves)
        end

      true ->
        # IO.puts("unable to test block at #{inspect(next_square)} - off map")
        blocks
    end
  end

  def visualise(map, seen) do
    Enum.map(map, fn {row, line} ->
      String.to_charlist(line)
      |> Enum.with_index()
      |> Enum.map(fn {val, col} ->
        cond do
          Map.has_key?(seen, {row, col}) ->
            Map.get(seen, {row, col}) |> Enum.random()

          # There may be multiple arrows for thsi square.
          # This will do for first draft visualisation as we
          # don't have suitable symbols

          true ->
            val
        end
      end)
      |> to_string()
    end)
  end

  ##### Visualise block and route for guard #####

  def visualise_block(map, block, moves) do
    map =
      set_char(map, block, "O")

    Enum.reduce(
      moves,
      map,
      fn {position, direction}, acc ->
        set_char(acc, position, get_direction_symbol(direction))
      end
    )
  end

  ##### Check the route contains a loop #####
  # used for debugging

  def check_cycle(moves) do
    {_map, loop, moves} =
      moves
      |> Enum.reverse()
      |> Enum.reduce_while({MapSet.new(), false, []}, fn move, {map, _loop, list} ->
        if !MapSet.member?(map, move) do
          {:cont, {MapSet.put(map, move), false, [move | list]}}
        else
          {:halt, {MapSet.put(map, move), true, [move | list]}}
        end
      end)

    {loop, moves}
  end

  ##### Get the updated direction based on map features #####

  def get_direction(grid, {row, col} = position, direction) do
    direction_num = rem(direction, 4)

    {{dir_row, dir_col}, _arrow} = @directions[direction_num]

    {next_row, next_col} = {row + dir_row, col + dir_col}

    cond do
      next_row < 0 or next_row >= map_size(grid) or next_col < 0 or
          next_col >= String.length(grid[0]) ->
        direction_num

      String.at(grid[next_row], next_col) == "#" ->
        get_direction(grid, position, direction + 1)

      String.at(grid[next_row], next_col) == "O" ->
        get_direction(grid, position, direction + 1)

      true ->
        direction_num
    end
  end
end
