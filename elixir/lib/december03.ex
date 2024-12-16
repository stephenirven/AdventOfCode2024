defmodule December03 do
  import Data

  ##### Day 03 - Part 1 solution #####

  def part1 do
    read("03")
    |> get_entries()
    |> get_muls()
    |> Enum.sum()
  end

  ##### Day 03 - Part 2 solution #####

  def part2 do
    result =
      read("03")
      |> get_entries_logic()
      |> parse_and_sum()

    IO.puts("The sum of logic parsed reports is: #{result.value}")
  end

  ##### Data processing #####

  # Get the entries for the input
  def get_entries(data) do
    Regex.scan(~r/mul\(([\d]{1,3}),([\d]{1,3})\)/, data)
  end

  # Get the multiples from the input
  def get_muls(entries) do
    entries
    |> Enum.map(fn [_mul, one, two] ->
      String.to_integer(one) * String.to_integer(two)
    end)
  end

  # Get the multiples and do / don't instructions
  def get_entries_logic(data) do
    Regex.scan(~r/mul\(([\d]{1,3}),([\d]{1,3})\)|do\(\)|don't\(\)/, data)
  end

  # Strip out the don't entries
  def parse_and_sum(entries) do
    List.foldl(entries, %{do: true, value: 0}, &sum/2)
  end

  def sum(elem, %{do: true, value: value} = acc) do
    case elem do
      ["don't()"] ->
        %{acc | do: false}

      ["do()"] ->
        acc

      [_mul, one, two] ->
        %{acc | value: value + String.to_integer(one) * String.to_integer(two)}
    end
  end

  def sum(elem, %{do: false, value: _value} = acc) do
    case elem do
      ["do()"] -> %{acc | do: true}
      _ -> acc
    end
  end


end
