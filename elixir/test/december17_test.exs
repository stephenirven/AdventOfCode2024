defmodule December17Test do
  use ExUnit.Case
  doctest December17
  import December17

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
end
