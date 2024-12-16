defmodule December04Test do
  use ExUnit.Case
  doctest December04
  import December04

  @cases """
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  """

  test "part 1 - the right number of XMAS entries found in sample data" do
    grid =
      @cases
      |> String.trim()
      |> get_grid()

    height = map_size(grid)
    width = String.length(grid[0])
    assert height == 10
    assert width == 10

    results = word_search(grid, "XMAS")

    assert length(results) == 18
  end

  test "part 2 - the right number of XMAS entries found in sample data" do
    grid =
      @cases
      |> String.trim()
      |> get_grid()

    height = map_size(grid)
    width = String.length(grid[0])
    assert height == 10
    assert width == 10

    results = xmas_search(grid)

    assert length(results) == 9
  end
end
