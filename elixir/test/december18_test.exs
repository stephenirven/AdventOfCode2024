defmodule December18Test do
  use ExUnit.Case
  doctest December18
  import December18
  import Maps.CodepointMap
  import Data

  @cases """
  5,4
  4,2
  4,5
  3,0
  2,1
  6,3
  2,4
  1,5
  0,6
  3,3
  2,6
  5,1
  1,2
  5,5
  2,5
  6,5
  1,4
  0,4
  6,4
  1,1
  6,1
  1,0
  0,5
  1,6
  2,0
  """

  @cases2 """
  5,4
  """

  test "grid and drops work as expected" do
    grid = get_grid(7, 7)

    drops = @cases |> String.trim() |> get_drops()

    grid2 = process_drops(grid, drops, 12)

    assert grid2 == %{
             0 => %{0 => ".", 1 => ".", 2 => ".", 3 => "#", 4 => ".", 5 => ".", 6 => "."},
             1 => %{0 => ".", 1 => ".", 2 => "#", 3 => ".", 4 => ".", 5 => "#", 6 => "."},
             2 => %{0 => ".", 1 => ".", 2 => ".", 3 => ".", 4 => "#", 5 => ".", 6 => "."},
             3 => %{0 => ".", 1 => ".", 2 => ".", 3 => "#", 4 => ".", 5 => ".", 6 => "#"},
             4 => %{0 => ".", 1 => ".", 2 => "#", 3 => ".", 4 => ".", 5 => "#", 6 => "."},
             5 => %{0 => ".", 1 => "#", 2 => ".", 3 => ".", 4 => "#", 5 => ".", 6 => "."},
             6 => %{0 => "#", 1 => ".", 2 => "#", 3 => ".", 4 => ".", 5 => ".", 6 => "."}
           }

    route = solve(grid2, {0, 0}, {6, 6})

    # remove the starting node
    [_start | steps] = route

    assert length(steps) == 22

    route_map =
      Enum.reduce(route, grid2, fn coord, grid ->
        set_value(grid, coord, "O")
      end)

    assert route_map == %{
             0 => %{0 => "O", 1 => "O", 2 => ".", 3 => "#", 4 => "O", 5 => "O", 6 => "O"},
             1 => %{0 => ".", 1 => "O", 2 => "#", 3 => "O", 4 => "O", 5 => "#", 6 => "O"},
             2 => %{0 => ".", 1 => "O", 2 => "O", 3 => "O", 4 => "#", 5 => "O", 6 => "O"},
             3 => %{0 => ".", 1 => ".", 2 => ".", 3 => "#", 4 => "O", 5 => "O", 6 => "#"},
             4 => %{0 => ".", 1 => ".", 2 => "#", 3 => "O", 4 => "O", 5 => "#", 6 => "."},
             5 => %{0 => ".", 1 => "#", 2 => ".", 3 => "O", 4 => "#", 5 => ".", 6 => "."},
             6 => %{0 => "#", 1 => ".", 2 => "#", 3 => "O", 4 => "O", 5 => "O", 6 => "O"}
           }
  end

  test "part2" do
    grid = get_grid(71, 71)

    drops = read("18") |> String.trim() |> get_drops()

    IO.puts(length(drops))
    minimal = get_minimal_fail(grid, drops, 0, length(drops) - 1, length(drops) - 1)

    IO.puts(minimal)

    grid = process_drops(grid, drops, minimal - 1)

    route = solve(grid, {0, 0}, {70, 70})

    route_map =
      Enum.reduce(route, grid, fn coord, grid ->
        set_value(grid, coord, "O")
      end)

    drops = Enum.drop(drops, minimal - 1)
    coord = hd(drops)
    IO.inspect(coord)
    route_map = set_value(route_map, coord, "+")
    visualise_map(route_map)
  end
end
