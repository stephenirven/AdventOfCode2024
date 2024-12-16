defmodule December01Test do
  use ExUnit.Case
  doctest December01
  import December01

  @cases """
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  """

  test "the diffs for the test cases are as expected" do
    {list1, list2} = get_lists(@cases)

    diffs = diff(list1, list2)

    assert Enum.sum(diffs) == 11
  end

  test "the similarities for the test cases are as expected" do
    {list1, list2} = get_lists(@cases)

    similarities = similarities(list1, list2)

    assert Enum.sum(similarities) == 31
  end
end
