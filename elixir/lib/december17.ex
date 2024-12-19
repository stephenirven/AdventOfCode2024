defmodule December17 do
  import Data
  import Bitwise

  #
  @type machine() :: {integer(), integer(), integer()}
  # list(integer())
  @type instructions_map() :: %{required(integer) => integer}
  @type instructions_list() :: list(integer())
  # Day 17 - Part 1 - https://adventofcode.com/2024/day/17#part2

  def part1 do
    {machine, instructions_map, _} =
      read("17")
      |> get_problem()

    result =
      run(machine, instructions_map)
      |> Enum.join(",")

    IO.puts("The final output is: #{result}")
  end

  # Day 17 - Part 2 https://adventofcode.com/2024/day/17#part2

  # Too slow for the input provided.

  def part2 do
    IO.puts("Brute force on this will not complete in a reasonable time.")
    IO.puts("Solution to be added.")
    # Process.exit(self(), :heat_death_of_the_universe)

    {{_a, b, c}, instructions_map, instructions_list} =
      read("17")
      |> get_problem()

    result =
      run_until_match({trunc(:math.pow(2, 3 * 16)), b, c}, instructions_map, instructions_list)

    IO.puts("The lowest value for register A that outputs its own instructions is: #{result} ")
  end

  ##### Load and process the data #####

  @spec get_problem(binary()) :: {machine(), instructions_map(), instructions_list()}
  def get_problem(data) do
    [register_section, program_section] =
      data
      |> String.split("\n\n", trim: true)

    machine =
      register_section
      |> String.split("\n")
      |> Enum.map(fn line ->
        String.split(line, ":", trim: true)
      end)
      |> Enum.map(fn [_name, val] -> val end)
      |> Enum.map(fn value -> value |> String.trim() |> String.to_integer() |> abs end)
      |> Enum.take(3)
      |> List.to_tuple()

    [_prog, instructions] =
      program_section
      |> String.split(":", trim: true)

    instructions_list =
      instructions
      |> String.split(",")
      |> Enum.map(fn value -> value |> String.trim() |> String.to_integer() end)

    instructions_map =
      instructions_list
      |> Enum.with_index()
      |> Enum.map(fn {v, k} -> {k, v} end)
      |> Map.new()

    {machine, instructions_map, instructions_list}
  end

  ##### Helper to get the combo operand value #####
  @spec get_combo_operand(integer(), machine()) :: integer()
  def get_combo_operand(value, {a, b, c}) do
    case value do
      0 -> 0
      1 -> 1
      2 -> 2
      3 -> 3
      4 -> a
      5 -> b
      6 -> c
    end

    # 7 should not be present
  end

  ##### Run the instructions on the machine #####

  @spec run(machine(), instructions_map(), integer(), instructions_list()) :: nil
  def run(state, instructions, instruction_pointer \\ 0, output \\ [])

  def run(_state, instructions, instruction_pointer, output)
      when instruction_pointer >= map_size(instructions),
      do: Enum.reverse(output)

  @spec run(machine(), instructions_map(), integer(), instructions_list()) :: nil
  def run(state = {a, b, c}, instructions, instruction_pointer, output) do
    instruction = instructions[instruction_pointer]
    operand = instructions[instruction_pointer + 1]
    combo_operand = operand |> get_combo_operand(state)

    # IO.puts("#{inspect(state)}, #{instruction}, #{operand}, #{combo_operand}")

    case instruction do
      0 ->
        # adv instruction
        result = trunc(a / Integer.pow(2, combo_operand))
        run({result, b, c}, instructions, instruction_pointer + 2, output)

      1 ->
        # bxl instruction
        result = bxor(b, operand)
        run({a, result, c}, instructions, instruction_pointer + 2, output)

      2 ->
        # bst instruction
        result = rem(combo_operand, 8)
        run({a, result, c}, instructions, instruction_pointer + 2, output)

      3 ->
        # jnz instruction
        if a == 0 do
          run({a, b, c}, instructions, instruction_pointer + 2, output)
        else
          run({a, b, c}, instructions, operand, output)
        end

      4 ->
        # bxc instruction
        result = bxor(b, c)
        run({a, result, c}, instructions, instruction_pointer + 2, output)

      5 ->
        # out instruction
        result = rem(combo_operand, 8)
        output = [result | output]
        run({a, b, c}, instructions, instruction_pointer + 2, output)

      6 ->
        # bdv instruction
        result = trunc(a / Integer.pow(2, combo_operand))
        run({a, result, c}, instructions, instruction_pointer + 2, output)

      7 ->
        # cdv instruction
        result = trunc(a / Integer.pow(2, combo_operand))
        run({a, b, result}, instructions, instruction_pointer + 2, output)
    end
  end

  ##### Run from start to finish values for A #####
  @spec run_from(machine(), instructions_map(), integer(), integer(), instructions_list()) :: nil

  def run_from(_machine, _instructions_map, current, finish, _instructions_list)
      when current >= finish,
      do: nil

  def run_from({_a, b, c}, instructions_map, current, finish, instructions_list) do
    output = run({current, b, c}, instructions_map)

    IO.puts("currently: #{current} - #{output |> Enum.join(",")}")

    run_from({current, b, c}, instructions_map, current + 1, finish, instructions_list)
  end

  ##### Check if the provided machine and input generate the input list #####

  @spec generates_input(machine(), instructions_map(), integer(), instructions_list()) ::
          boolean()
  def generates_input(state, instructions_map, instruction_pointer \\ 0, instructions_list \\ [])

  # If we have processed all the instructions and the instructions_list has reduced to 0
  # It means we have generated the input
  def generates_input(_state, instructions_map, instruction_pointer, instructions_list)
      when instruction_pointer >= map_size(instructions_map),
      do: length(instructions_list) == 0

  def generates_input(state = {a, b, c}, instructions_map, instruction_pointer, instructions_list) do
    instruction = instructions_map[instruction_pointer]
    operand = instructions_map[instruction_pointer + 1]
    combo_operand = operand |> get_combo_operand(state)

    case instruction do
      0 ->
        # adv instruction
        result = trunc(a / Integer.pow(2, combo_operand))

        generates_input(
          {result, b, c},
          instructions_map,
          instruction_pointer + 2,
          instructions_list
        )

      1 ->
        # bxl instruction
        result = bxor(b, operand)

        generates_input(
          {a, result, c},
          instructions_map,
          instruction_pointer + 2,
          instructions_list
        )

      2 ->
        # bst instruction
        result = rem(combo_operand, 8)

        generates_input(
          {a, result, c},
          instructions_map,
          instruction_pointer + 2,
          instructions_list
        )

      3 ->
        # jnz instruction
        if a == 0 do
          generates_input({a, b, c}, instructions_map, instruction_pointer + 2, instructions_list)
        else
          generates_input({a, b, c}, instructions_map, operand, instructions_list)
        end

      4 ->
        # bxc instruction
        result = bxor(b, c)

        generates_input(
          {a, result, c},
          instructions_map,
          instruction_pointer + 2,
          instructions_list
        )

      5 ->
        # out instruction
        result = rem(combo_operand, 8)

        [head | tail] = instructions_list

        if result != head do
          false
        else
          generates_input({a, b, c}, instructions_map, instruction_pointer + 2, tail)
        end

      6 ->
        # bdv instruction
        result = trunc(a / Integer.pow(2, combo_operand))

        generates_input(
          {a, result, c},
          instructions_map,
          instruction_pointer + 2,
          instructions_list
        )

      7 ->
        # cdv instruction
        result = trunc(a / Integer.pow(2, combo_operand))

        generates_input(
          {a, b, result},
          instructions_map,
          instruction_pointer + 2,
          instructions_list
        )
    end
  end

  ##### Attempts to brute force a solution for the machine to return its instructions #####

  @spec run_until_match(machine(), instructions_map(), instructions_list()) :: integer()
  def run_until_match({a, b, c}, instructions_map, instructions_list) do
    # show a bit of output so you know the universe is still running...
    if rem(a, 100_000_000) == 0, do: IO.puts(a)

    cond do
      generates_input({a, b, c}, instructions_map, 0, instructions_list) ->
        a

      true ->
        run_until_match({a + 1, b, c}, instructions_map, instructions_list)
    end
  end
end
