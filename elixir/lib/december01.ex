defmodule December01 do
  import Data

  #
  # https://adventofcode.com/2024/day/1#part2
  #

  def part1 do
    {list1, list2} =
      read("01")
      |> get_lists()

    diffs = diff(list1, list2)

    IO.puts("Total distance: #{Enum.sum(diffs)}")
  end

  #
  # https://adventofcode.com/2024/day/1#part2
  #

  def part2 do
    {list1, list2} =
      read("01")
      |> get_lists()

    similarities = similarities(list1, list2)

    IO.puts(" Similarity of the lists: #{Enum.sum(similarities)}")
  end

  #### Data processing #####

  def get_lists(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, ~r"\s+")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Enum.unzip()
  end

  ##### Get the differences between the sorted lists #####
  def diff(list1, list2) do
    list1 = Enum.sort(list1)
    list2 = Enum.sort(list2)

    zip = Enum.zip(list1, list2)

    Enum.map(
      zip,
      fn {val1, val2} ->
        abs(val1 - val2)
      end
    )
  end

  ##### Get the similarity score for the lists #####

  def similarities(list1, list2) do
    list1 = Enum.sort(list1)
    list2 = Enum.sort(list2)

    occurance = list2 |> Enum.frequencies()

    list1
    |> Enum.map(fn number ->
      number * Map.get(occurance, number, 0)
    end)
  end
end
