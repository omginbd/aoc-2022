defmodule Day01 do
  def p1 do
    input = File.read!("./inputs/day01.txt")

    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn elf ->
      elf
      |> String.split("\n", trim: true)
      |> Enum.reduce(0, fn cals, acc ->
        acc + String.to_integer(cals)
      end)
    end)
    |> Enum.sort(:desc)
    |> List.first()
  end

  def p2 do
    input = File.read!("./inputs/day01.txt")

    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn group ->
      group
      |> String.split("\n", trim: true)
      |> Enum.reduce(0, fn cals, acc ->
        acc + String.to_integer(cals)
      end)
    end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
