defmodule Day06 do
  def part1 do
    input = File.read!("./inputs/day06.txt")
    find_start_of_message(input, 4)
  end

  def part2 do
    input = File.read!("./inputs/day06.txt")
    find_start_of_message(input, 14)
  end

  defp find_start_of_message(input, length) do
    input
    |> String.graphemes()
    |> Enum.chunk_every(length, 1)
    |> Enum.find_index(&(&1 |> Enum.uniq() |> Enum.count() === length))
    |> Kernel.+(length)
  end
end
