defmodule December14Test do
  use ExUnit.Case
  doctest December14
  import December14
  import Data

  @cases """
  p=0,4 v=3,-3
  p=6,3 v=-1,-3
  p=10,3 v=-1,2
  p=2,0 v=2,-1
  p=0,0 v=1,3
  p=3,0 v=-2,-2
  p=7,6 v=-1,-3
  p=3,0 v=-1,-2
  p=9,3 v=2,3
  p=7,3 v=-1,2
  p=2,4 v=2,-3
  p=9,5 v=-3,-3
  """

  test "robots work as expected" do
    robots =
      @cases
      |> get_robots()

    assert robots == [
             {{0, 4}, {3, -3}},
             {{6, 3}, {-1, -3}},
             {{10, 3}, {-1, 2}},
             {{2, 0}, {2, -1}},
             {{0, 0}, {1, 3}},
             {{3, 0}, {-2, -2}},
             {{7, 6}, {-1, -3}},
             {{3, 0}, {-1, -2}},
             {{9, 3}, {2, 3}},
             {{7, 3}, {-1, 2}},
             {{2, 4}, {2, -3}},
             {{9, 5}, {-3, -3}}
           ]

    IO.inspect(robots)
    max_rows = 7
    max_cols = 11

    map = visualise_robots(robots, {max_cols, max_rows})
    IO.inspect(map)

    robots =
      Enum.map(robots, fn robot ->
        move_robot(robot, {max_cols, max_rows}, 100)
      end)

    assert robots == [
             {{3, 5}, {3, -3}},
             {{5, 4}, {-1, -3}},
             {{9, 0}, {-1, 2}},
             {{4, 5}, {2, -1}},
             {{1, 6}, {1, 3}},
             {{1, 3}, {-2, -2}},
             {{6, 0}, {-1, -3}},
             {{2, 3}, {-1, -2}},
             {{0, 2}, {2, 3}},
             {{6, 0}, {-1, 2}},
             {{4, 5}, {2, -3}},
             {{6, 6}, {-3, -3}}
           ]

    IO.inspect(robots)

    map = visualise_robots(robots, {max_cols, max_rows})
    IO.inspect(map)

    quads = [ul, ur, ll, lr] = quadrants(robots, {max_cols, max_rows})

    map = visualise_robots(ul ++ ur ++ ll ++ lr, {max_cols, max_rows})

    IO.inspect(map)

    safety =
      Enum.reduce(quads, 1, fn quad, acc ->
        length(quad) * acc
      end)

    assert length(ul) * length(ur) * length(ll) * length(lr) == 12
  end

  test "quadrants works with even and odd number of rows / cols" do
    robots =
      for x <- 0..9, y <- 0..9 do
        {{x, y}, {0, 0}}
      end

    map = visualise_robots(robots, {10, 10})
    IO.inspect(map)

    quads = quadrants(robots, {10, 10})

    quad_counts = Enum.map(quads, &Enum.count/1)
    assert Enum.all?(quad_counts, &(&1 == 25))

    assert Enum.sum(quad_counts) == Enum.count(robots)

    robots =
      for x <- 0..10, y <- 0..10 do
        {{x, y}, {0, 0}}
      end

    map = visualise_robots(robots, {11, 11})
    IO.inspect(map)

    quads = quadrants(robots, {11, 11})

    map = visualise_robots(List.flatten(quads), {11, 11})

    IO.inspect(map)
    quad_counts = Enum.map(quads, &Enum.count/1)
    assert Enum.all?(quad_counts, &(&1 == 25))

    # Check that one horizontal row has been removed,
    # and one vertical row - overlaps by 1
    assert Enum.sum(quad_counts) == Enum.count(robots) - 11 - 10
  end

  test "Christmas tree" do
    robots =
      read("14")
      |> get_robots()

    max_rows = 103
    max_cols = 101

    robots =
      Enum.map(robots, fn robot ->
        move_robot(robot, {max_cols, max_rows}, 100)
      end)

    visualise_robots(robots, {max_cols, max_rows})
  end
end
