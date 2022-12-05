defmodule Day05 do
  def part1 do
    input = File.read!("./inputs/day05.txt")

    [stacks, instructions] = String.split(input, "\n\n", trim: true)

    make_stack_map(stacks)
    |> follow_instructions(String.split(instructions, "\n", trim: true))
    |> get_answer()
  end

  def part2 do
    input = File.read!("./inputs/day05.txt")

    [stacks, instructions] = String.split(input, "\n\n", trim: true)

    make_stack_map(stacks)
    |> follow_instructions_p2(String.split(instructions, "\n", trim: true))
    |> get_answer()
  end

  defp get_answer(stacks) do
    Map.keys(stacks)
    |> Enum.map(&(stacks |> Map.get(&1) |> List.first()))
    |> Enum.join()
  end

  def follow_instructions_p2(stacks, []), do: stacks

  def follow_instructions_p2(stacks, [head | rest]) do
    [num, from, to] = Regex.run(~r/move (\d+) from (\d+) to (\d+)/, head) |> tl

    num = String.to_integer(num)

    to_move =
      stacks
      |> Map.get(from)
      |> Enum.take(num)

    stacks =
      stacks
      |> Map.update(from, :error, fn old_stack ->
        {_, rest} = Enum.split(old_stack, num)
        rest
      end)
      |> Map.update(to, :error, fn old_stack ->
        to_move ++ old_stack
      end)

    follow_instructions_p2(stacks, rest)
  end

  def follow_instructions(stacks, []), do: stacks

  def follow_instructions(stacks, [head | rest]) do
    [num, from, to] = Regex.run(~r/move (\d+) from (\d+) to (\d+)/, head) |> tl

    num = String.to_integer(num)

    to_move =
      stacks
      |> Map.get(from)
      |> Enum.take(num)
      |> Enum.reverse()

    stacks =
      stacks
      |> Map.update(from, :error, fn old_stack ->
        {_, rest} = Enum.split(old_stack, num)
        rest
      end)
      |> Map.update(to, :error, fn old_stack ->
        to_move ++ old_stack
      end)

    follow_instructions(stacks, rest)
  end

  defp make_stack_map(stacks) do
    [headers | rows] =
      String.split(stacks, "\n")
      |> Enum.reverse()

    empty_map =
      headers
      |> String.split(" ", trim: true)
      |> Enum.into(%{}, fn num -> {num, []} end)

    Enum.reduce(rows, empty_map, fn row, map ->
      boxes =
        row
        |> String.replace("             ", " [0] [0] [0] ")
        |> String.replace("         ", " [0] [0] ")
        |> String.replace("     ", " [0] ")
        |> String.split(" ")
        |> Enum.map(fn box -> String.replace(box, ["[", "]"], "") end)

      Enum.reduce(Enum.with_index(boxes), map, fn {box, index}, acc ->
        Map.update(acc, to_string(index + 1), [box], fn old -> [box | old] end)
      end)
    end)
    |> Enum.into(%{}, fn {key, val} ->
      {key, val |> Enum.reject(&(&1 === "0"))}
    end)
  end
end
