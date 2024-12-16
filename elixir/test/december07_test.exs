defmodule December07Test do
  use ExUnit.Case
  doctest December07
  import December07

  @cases """
  190: 10 19
  3267: 81 40 27
  83: 17 5
  156: 15 6
  7290: 6 8 6 15
  161011: 16 10 13
  192: 17 8 14
  21037: 9 7 18 13
  292: 11 6 16 20
  """

  test "part 1 - sums behave as expected" do
    lines =
      @cases
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

    assert Enum.sum(results) == 3749
  end

  test "part 2 - silly sums work as expected" do
    lines =
      @cases
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

    assert Enum.sum(results) == 11387
  end
end
