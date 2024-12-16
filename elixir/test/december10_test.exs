defmodule December10Test do
  use ExUnit.Case
  doctest December10
  import December10

  # @cases """
  # 10..9..
  # 2...8..
  # 3...7..
  # 4567654
  # ...8..3
  # ...9..2
  # .....01
  # """
  @cases """
  89010123
  78121874
  87430965
  96549874
  45678903
  32019012
  01329801
  10456732
  """

  test "map works as expected" do
    map =
      @cases
      |> get_map()

    rows = map_size(map)
    assert rows == 8
    cols = map_size(map[0])
    assert cols == 8

    trailheads = get_trailheads(map, 0)

    assert length(trailheads) == 9

    scores =
      Enum.map(trailheads, fn head ->
        get_trails(map, head, false)
      end)
      |> Enum.map(&Enum.count/1)

    assert scores == [5, 6, 5, 3, 1, 3, 5, 3, 5]
    assert Enum.sum(scores) == 36
  end

  test "with updated coordinates, machines work as expected" do
    map =
      @cases
      |> get_map()

    rows = map_size(map)
    assert rows == 8
    cols = map_size(map[0])
    assert cols == 8

    trailheads = get_trailheads(map, 0)

    assert length(trailheads) == 9

    trails =
      Enum.map(trailheads, fn head ->
        get_trails(map, head, true)
      end)

    IO.inspect(trails)

    scores = trails |> Enum.map(&Enum.count/1)

    IO.inspect(scores)
    assert scores == [20, 24, 10, 4, 1, 4, 5, 8, 5]
    assert Enum.sum(scores) == 81
  end
end
