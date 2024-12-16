defmodule December03Test do
  use ExUnit.Case
  doctest December03
  import December03

  @cases "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

  @cases2 "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

  test "part 1 - the multiplier values are as expected" do
    sum =
      @cases
      |> get_entries()
      |> get_muls()
      |> Enum.sum()

    expected = 161

    assert sum == expected
  end

  test "part 2 - the safety of the test cases is as expected" do
    result =
      @cases2
      |> get_entries_logic()
      |> parse_and_sum()

    expected = 48

    assert result.value == expected
  end
end
