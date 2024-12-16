defmodule December04 do
  import Data

  ##### Day 4 - Part 1 solution #####

  def part1 do
    results =
      read("04")
      |> get_grid()
      |> word_search("XMAS")

    IO.puts("The number of times XMAS appears in the grid is: #{length(results)}")
  end

  ##### Day 4 - Part 2 solution #####

  def part2 do
    results =
      read("04")
      |> get_grid()
      |> xmas_search()

    IO.puts("The number of times X-MAS appears in the grid is #{length(results)}")
  end

  ##### Data processing #####

  def get_grid(data) do
    data
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(fn {v, k} -> {k, v} end)
    |> Map.new()
  end

  ##### Find the given word in the grid #####

  def word_search(grid, word) do
    height = map_size(grid)
    width = String.length(grid[0])

    for row <- 0..(height - 1),
        col <- 0..(width - 1),
        dir_c <- -1..1,
        dir_r <- -1..1,
        {0, 0} != {dir_r, dir_c} do
      word_location = find(grid, word, row, col, %{r: dir_r, c: dir_c}, [])

      if word_location do
        word_location
      end
    end
    |> Enum.filter(&(&1 != nil))
  end

  def find(_grid, word, _row, _col, _dir, acc) when word == "", do: acc

  def find(grid, _word, row, _col, _dir, _acc) when row < 0 or row >= map_size(grid), do: false

  def find(grid, word, row, col, dir, acc) do
    cond do
      col < 0 or col > String.length(grid[0]) - 1 ->
        false

      String.at(grid[row], col) == String.at(word, 0) ->
        remaining_word = String.slice(word, 1, String.length(word))

        next_row = row + dir.r
        next_col = col + dir.c

        find(grid, remaining_word, next_row, next_col, dir, [
          %{r: row, c: col} | acc
        ])

      true ->
        false
    end
  end

    ##### Search the grid for X-MAS occurances #####

    def xmas_search(grid) do
      height = map_size(grid)
      width = String.length(grid[0])

      # we can trim off the outer rows and columns
      for row <- 1..(height - 2), col <- 1..(width - 2) do
        if is_xmas(grid, row, col) do
          %{r: row, c: col}
        end
      end
      |> Enum.filter(&(&1 != nil))
    end

    def is_xmas(grid, row, col) do
      if String.at(grid[row], col) != "A" do
        false
      else
        tl = String.at(grid[row - 1], col - 1)
        bl = String.at(grid[row + 1], col - 1)
        tr = String.at(grid[row - 1], col + 1)
        br = String.at(grid[row + 1], col + 1)

        line1 = tl <> br
        line2 = bl <> tr

        (line1 == "MS" or line1 == "SM") and (line2 == "MS" or line2 == "SM")
      end
    end

end
