defmodule December14 do
  import Data

  # Day 14 - part 1 solution

  def part1 do
    robots = read("14") |> get_robots()

    max_rows = 103
    max_cols = 101

    robots = Enum.map(robots, fn robot -> move_robot(robot, {max_cols, max_rows}, 100) end)

    quads = quadrants(robots, {max_cols, max_rows})

    safety =
      Enum.reduce(quads, 1, fn quad, acc ->
        length(quad) * acc
      end)

    IO.puts("The safety factor after 100 seconds is: #{safety}")
  end

  # Day 14 - Part 2 solution.
  # Attempts to find sequences of 10 robots in a line.
  # Not efficient, but in tests, 96 trees were found in the first
  # 1 million frames in a reasonable time.

  def part2 do
    robots = read("14") |> get_robots()

    max_rows = 103
    max_cols = 101

    {:ok, file} = File.open(Path.expand("./tree.txt", __DIR__), [:append])

    for frame <- 0..10_000 do
      robots =
        Enum.map(robots, fn robot ->
          move_robot(robot, {max_cols, max_rows}, frame)
        end)

      map = visualise_robots(robots, {max_cols, max_rows})
      match = Enum.any?(map, fn line -> String.contains?(line, "XXXXXXXXXX") end)

      # for line <- visualise_robots(robots, {max_cols, max_rows}) do
      if match do
        IO.binwrite(file, "((Frame: #{frame}))\n\n")
        Enum.each(map, &IO.binwrite(file, &1 <> "\n"))
      end

      # end
    end

    File.close(file)
    IO.puts("Check tree.txt for results")
  end

  ##### Loading data #####

  def get_robots(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, " ")
      |> Enum.map(fn part ->
        String.split(part, ",")
        |> Enum.map(fn ord ->
          cond do
            String.at(ord, 0) in ["p", "v"] ->
              {_, ord} = String.split_at(ord, 2)
              String.to_integer(ord)

            true ->
              String.to_integer(ord)
          end
        end)
        |> List.to_tuple()
      end)
      |> List.to_tuple()
    end)
  end

  ##### Output for visualisation and verification #####

  def visualise_robots(robots, {max_x, max_y}) do
    map =
      for _row <- 0..(max_y - 1) do
        String.duplicate(".", max_x)
      end
      |> Enum.with_index()
      |> Enum.map(fn {v, k} -> {k, v} end)
      |> Map.new()

    map =
      Enum.reduce(robots, map, fn {{x, y}, {_vx, _vy}}, acc ->
        set_char(acc, {y, x}, "X")
      end)

    for row <- 0..(max_y - 1) do
      map[row]
    end
  end

  ##### Move the robot to the frame number #####

  def move_robot({{pos_x, pos_y}, vel = {v_x, v_y}}, {max_x, max_y}, number) do
    x = rem(pos_x + number * v_x, max_x)
    y = rem(pos_y + number * v_y, max_y)

    x = if x < 0, do: x + max_x, else: x
    y = if y < 0, do: y + max_y, else: y

    {{x, y}, vel}
  end

  ##### Split the map into four equal quadrants #####

  def quadrants(robots, {max_x, max_y}) do
    upper =
      Enum.filter(robots, fn {{_x, y}, {_dx, _dy}} ->
        y < div(max_y, 2)
      end)

    upper_left =
      Enum.filter(upper, fn {{x, _y}, {_dx, _dy}} ->
        x < div(max_x, 2)
      end)

    upper_right =
      Enum.filter(upper, fn {{x, _y}, {_dx, _dy}} ->
        if rem(max_x, 2) == 0 do
          x >= div(max_x, 2)
        else
          x > div(max_x, 2)
        end
      end)

    lower =
      Enum.filter(robots, fn {{_x, y}, {_dx, _dy}} ->
        if rem(max_y, 2) == 0 do
          y >= div(max_y, 2)
        else
          y > div(max_y, 2)
        end
      end)

    lower_left =
      Enum.filter(lower, fn {{x, _y}, {_dx, _dy}} ->
        x < div(max_x, 2)
      end)

    lower_right =
      Enum.filter(lower, fn {{x, _y}, {_dx, _dy}} ->
        if rem(max_y, 2) == 0 do
          x >= div(max_x, 2)
        else
          x > div(max_x, 2)
        end
      end)

    [upper_left, upper_right, lower_left, lower_right]
  end
end
