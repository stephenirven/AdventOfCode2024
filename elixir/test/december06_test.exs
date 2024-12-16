defmodule December06Test do
  use ExUnit.Case
  doctest December06
  import December06

  @cases """
  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ..........
  .#..^.....
  ........#.
  #.........
  ......#...
  """

  test "part 1 - guard behaves as expected" do
    {map, position} =
      @cases
      |> String.trim()
      |> parse()

    assert map_size(map) == 10
    assert String.length(map[0]) == 10
    assert position == {6, 4}

    {squares, moves} = seen_squares(map, position, 0)
    IO.inspect(squares)

    out = visualise(map, squares)

    IO.inspect(out)
    IO.inspect(moves)
    count = map_size(squares)
    IO.puts("Number of squares: #{count}")
    assert count == 41
  end

  test "part 2 - make the guard go in a loop" do
    {map, position} =
      @cases
      |> String.trim()
      |> parse()

    blocks =
      seen_squares_block(map, position, 0, map_size(map), String.length(map[0]))

    assert Map.keys(blocks) == [{6, 3}, {7, 6}, {7, 7}, {8, 1}, {8, 3}, {9, 7}]

    for {_block, moves} <- blocks do
      {loop, _moves} = check_cycle(moves)
      assert loop == true
    end

    #    IO.inspect(visualise_blocks(map, blocks))
  end
end
