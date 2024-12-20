defmodule December20 do
  import Maps.CodepointMap
  import Data

  ##### Day 20 - part 1 - https://adventofcode.com/2024/day/20 #####

  def part1 do
    {map, track} =
      read("20")
      |> get_problem()

    cheats = get_cheats(map, track)

    cheats_over_100 = cheats |> Enum.map(fn {k, v} -> v end) |> Enum.filter(fn v -> v >= 100 end)

    IO.puts("The number of cheats over 100 picoseconds is #{Enum.count(cheats_over_100)}")
  end

  ##### Day 20 - part 2 - https://adventofcode.com/2024/day/20 #####

  def part2 do
    {_map, track} =
      read("20")
      |> get_problem()

    min_saving = 100
    max_jump_time = 20

    cheats =
      Enum.reduce(track, %{}, fn {location, _saving}, acc ->
        Map.merge(acc, Map.new(get_jumps_within(track, location, max_jump_time, min_saving)))
      end)

    # IO.inspect(cheats, limit: :infinity)

    IO.puts(
      "There are #{Enum.count(cheats)} cheats that save at least #{min_saving} picoseconds for a cost of max #{max_jump_time}"
    )
  end

  ##### Data import and processing #####

  def get_problem(data) do
    map = data |> create_map()

    start = hd(find_value(map, "S"))

    track = get_track(map, start)

    {map, track}
  end

  ##### Get a map of coordinate pairs to index in the list of moves

  def get_track(map, current = {r, c}, seen \\ MapSet.new(), track \\ []) do
    seen = MapSet.put(seen, current)
    track = [current | track]

    if map[r][c] == "E" do
      Enum.reverse(track)
      |> Enum.with_index()
      |> Map.new()
    else
      [next] =
        get_adjacent(map, current)
        |> Enum.filter(fn {r, c} ->
          !MapSet.member?(seen, {r, c}) and
            (map[r][c] == "." or map[r][c] == "E")
        end)

      get_track(map, next, seen, track)
    end
  end

  ##### Get cheats available at each location in the route #####

  def get_cheats(map, track) do
    locations = Map.keys(track)

    Enum.reduce(locations, Map.new(), fn {rl, cl} = location, cheat_map ->
      cheats =
        get_adjacent_plus_one(map, location)
        |> Enum.filter(fn hoppable ->
          if !Map.has_key?(track, hoppable) do
            false
          else
            {:ok, cheat_index} = Map.fetch(track, hoppable)
            {:ok, current_index} = Map.fetch(track, location)
            cheat_index - current_index > 2
          end
        end)

      if length(cheats) > 0 do
        Enum.reduce(cheats, cheat_map, fn cheat_location = {rc, cc}, acc ->
          {:ok, cheat_index} = Map.fetch(track, cheat_location)
          {:ok, current_index} = Map.fetch(track, location)

          Map.put(
            acc,
            {{div(rc + rl, 2), div(cc + cl, 2)}, {rc, cc}},
            cheat_index - current_index - 2
          )
        end)
      else
        cheat_map
      end
    end)
  end

  ##### Get any coordinates adjacent plus 1 to the location #####

  def get_adjacent_plus_one(map, {r, c}) do
    [
      {r - 2, c},
      {r, c + 2},
      {r + 2, c},
      {r, c - 2}
    ]
    |> Enum.filter(fn {r, c} -> in_map(map, {r, c}) end)
  end

  ##### Get jumps for a location that are within a manhattan distance on the route, with at least minimum saving #####

  def get_jumps_within(track, {r, c}, max_manhattan, min_saving) do
    Enum.filter(track, fn {{jr, jc}, index} ->
      manhattan_distance = abs(jr - r) + abs(jc - c)
      saving = index - track[{r, c}] - manhattan_distance

      manhattan_distance <= max_manhattan and saving >= min_saving
    end)
    |> Enum.map(fn {{jr, jc}, index} ->
      manhattan_distance = abs(jr - r) + abs(jc - c)
      saving = index - track[{r, c}] - manhattan_distance
      {{{r, c}, {jr, jc}}, saving}
    end)
  end
end
