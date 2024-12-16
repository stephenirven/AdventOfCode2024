defmodule December07 do
  import Data
  ##### Day 07 - Part 1 solution #####

  def part1 do
    lines =
      read("07")
      |> String.trim()
      |> get_lines()

    results =
      lines
      |> Enum.map(fn {sum, elements} ->
        combinations = get_combinations(sum, elements)

        if length(combinations) > 0 do
          sum
        else
          0
        end
      end)

    IO.puts("The total calibration result is #{Enum.sum(results)}")
  end

  ##### Day 07 - Part 2 solution #####

  def part2 do
    lines =
      read("07")
      |> String.trim()
      |> get_lines()

    results =
      lines
      |> Enum.map(fn {sum, elements} ->
        combinations = get_silly_combinations(sum, elements)

        if length(combinations) > 0 do
          sum
        else
          0
        end
      end)

    IO.puts("The total silly calibration result is #{Enum.sum(results)}")
  end

  ##### Data processing #####

  def get_lines(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn s -> String.split(s, ":", trim: true) end)
    |> Enum.map(fn [s, v] ->
      {String.to_integer(s), String.split(v, " ", trim: true) |> Enum.map(&String.to_integer/1)}
    end)
  end

  def add_if(list, condition, item) do
    if condition, do: [item | list], else: list
  end

  ##### Get the combinations

  def get_combinations(target, [head | tail]) do
    get_combinations(target, tail, {head, []})
  end

  def get_combinations(target, [], {current, operators}) when current == target,
    do: Enum.reverse(operators)

  def get_combinations(_target, [], {_current, _operators}), do: []

  def get_combinations(target, [head | tail], {current, operators}) do
    plus = get_combinations(target, tail, {current + head, ["+" | operators]})

    values = add_if([], length(plus) > 0, plus)
    mult = get_combinations(target, tail, {current * head, ["*" | operators]})
    add_if(values, length(mult) > 0, mult)
  end

  def get_silly_combinations(target, [head | tail]) do
    get_silly_combinations(target, tail, {head, []})
  end

  ##### combinations including silly operator for part 2 #####

  def get_silly_combinations(target, [], {current, operators}) when current == target,
    do: Enum.reverse(operators)

  def get_silly_combinations(_target, [], {_current, _operators}), do: []

  def get_silly_combinations(target, [head | tail], {current, operators}) do
    plus = get_silly_combinations(target, tail, {current + head, ["+" | operators]})

    values = add_if([], length(plus) > 0, plus)
    mult = get_silly_combinations(target, tail, {current * head, ["*" | operators]})
    values = add_if(values, length(mult) > 0, mult)

    concat = String.to_integer(to_string(current) <> to_string(head))
    silly = get_silly_combinations(target, tail, {concat, ["*" | operators]})
    add_if(values, length(silly) > 0, silly)
  end
end
