defmodule December20Test do
  use ExUnit.Case
  doctest December20
  import December20
  import Maps.CodepointMap

  @cases """
  ###############
  #...#...#.....#
  #.#.#.#.#.###.#
  #S#...#.#.#...#
  #######.#.#.###
  #######.#.#...#
  #######.#.###.#
  ###..E#...#...#
  ###.#######.###
  #...###...#...#
  #.#####.#.###.#
  #.#...#.#.#...#
  #.#.#.#.#.#.###
  #...#...#...###
  ###############
  """

  @cases2 """
  S..#
  ##.#
  #..#
  #.##
  #..#
  ##.#
  #..#
  #.##
  #..E
  """

  test "solution of jump 2 works as expected" do
    {map, track} =
      @cases
      |> String.trim()
      |> get_problem()

    cheats = get_cheats(map, track)

    cheat_savings = cheats |> Enum.map(fn {k, v} -> v end) |> Enum.frequencies()

    assert cheat_savings == %{
             2 => 14,
             4 => 14,
             6 => 2,
             8 => 4,
             10 => 2,
             12 => 3,
             20 => 1,
             36 => 1,
             38 => 1,
             40 => 1,
             64 => 1
           }

    cheat_map =
      cheats
      |> Map.keys()
      |> Enum.reduce(map, fn {one, two}, acc ->
        # IO.inspect(one)
        acc = set_value(acc, one, "@")
        acc = set_value(acc, two, "@")

        acc
      end)

    visualise_map(cheat_map)
  end

  test "solution of jump up to n for saving m works as expected" do
    {map, track} =
      @cases
      |> String.trim()
      |> get_problem()

    cheats =
      Enum.reduce(track, %{}, fn {location, _saving}, acc ->
        Map.merge(acc, Map.new(get_jumps_within(track, location, 20, 50)))
      end)
      |> Enum.sort(fn {_k, v}, {_k2, v2} -> v < v2 end)

    frequencies =
      cheats
      |> Enum.map(fn {k, v} -> v end)
      |> Enum.frequencies()

    assert frequencies == %{
             50 => 32,
             52 => 31,
             54 => 29,
             56 => 39,
             58 => 25,
             60 => 23,
             62 => 20,
             64 => 19,
             66 => 12,
             68 => 14,
             70 => 12,
             72 => 22,
             74 => 4,
             76 => 3
           }
  end
end
