defmodule December17Test do
  use ExUnit.Case
  doctest December17
  import December17
  import Data

  @cases """
  Register A: 729
  Register B: 0
  Register C: 0

  Program: 0,1,5,4,3,0
  """
  @cases2 """
  Register A: 2024
  Register B: 0
  Register C: 0

  Program: 0,3,5,4,3,0
  """

  test "registers work expected" do
    {machine, instructions_map, _instructions_list} =
      @cases
      |> get_problem()

    result =
      run(machine, instructions_map)
      |> Enum.join(",")

    assert result == "4,6,3,5,6,3,5,2,1,0"
  end

  test "run until match works" do
    {machine = {_a, b, c}, instructions_map, instructions_list} =
      @cases2
      |> get_problem()

    result =
      run_until_match({0, b, c}, instructions_map, instructions_list)

    assert result == 117_440
  end

  test "run from " do
    {machine = {_a, b, c}, instructions_map, instructions_list} =
      read("17")
      |> get_problem()

    start = 281_475_000_000_000
    IO.puts(start)
    finish = start + 1000
    run_from(machine, instructions_map, start, finish, instructions_list)
    # 2,4,1,3,7,5,4,2,0,3,1,5,5,5,3,0

    # extra digit at 8, 64, 512
    # 2^3, 2^6, 2^9
  end
end
