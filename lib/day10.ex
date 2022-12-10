defmodule Day10 do
  def part1 do
    input = File.read!("./inputs/day10.txt")

    vm = %{
      x: 1,
      cycles: 0
    }

    input
    |> String.split("\n", trim: true)
    |> process_instructions(vm, 1, [])
    |> Enum.with_index(1)
    |> Enum.filter(fn {_val, num} -> num in 20..220//40 end)
    |> Enum.map(fn {val, num} -> val * num end)
    |> Enum.sum()
  end

  def part2 do
    input = File.read!("./inputs/day10.txt")

    vm = %{
      x: 1,
      cycles: 0
    }

    IEx.Helpers.clear()

    input
    |> String.split("\n", trim: true)
    |> process_instructions(vm, 1, [])
    |> Enum.with_index()
    |> draw_pixels([])
    |> pretty_print()

    IO.write(IO.ANSI.cursor_down(8))
    nil
  end

  defp pretty_print(pixels) do
    pixels
    |> Enum.reverse()
    |> Enum.chunk_every(40)
    |> Enum.map(&Enum.join/1)
    |> Enum.with_index(1)
    |> Enum.map(fn {line, index} ->
      IO.write("\r")
      IO.write(line)
      IO.write("\n")
      index
    end)
    |> Enum.max()
    |> IO.ANSI.cursor_up()
    |> IO.write()

    pixels
  end

  defp draw_pixels([], acc), do: acc

  defp draw_pixels([{x, cycle} | tail], acc) when rem(cycle, 40) in (x - 1)..(x + 1) do
    :timer.sleep(50)
    draw_pixels(tail, pretty_print(["#" | acc]))
  end

  defp draw_pixels([{x, cycle} | tail], acc) do
    :timer.sleep(50)
    draw_pixels(tail, pretty_print(["." | acc]))
  end

  defp process_instructions([], vm, counter, acc) do
    Enum.reverse([vm.x | acc])
  end

  defp process_instructions(["noop" | tail], vm, counter, acc) do
    process_instructions(tail, %{vm | cycles: vm.cycles + 1}, counter + 1, [vm.x | acc])
  end

  defp process_instructions(["addx " <> num | tail], vm, counter, acc) do
    process_instructions(
      tail,
      %{vm | cycles: vm.cycles + 2, x: vm.x + String.to_integer(num)},
      counter + 2,
      [vm.x | [vm.x | acc]]
    )
  end
end
