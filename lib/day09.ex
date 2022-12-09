defmodule Day09 do
  # 6209
  def part1 do
    input = File.read!("./inputs/day09.txt")

    input
    |> String.split("\n", trim: true)
    |> map_instructions([])
    |> follow_instructions([{0, 0}, {0, 0}], MapSet.put(MapSet.new(), {0, 0}))
  end

  def part2 do
    input = File.read!("./inputs/day09.txt")

    knots = Enum.map(0..9, fn _ -> {0, 0} end)

    input
    |> String.split("\n", trim: true)
    |> map_instructions([])
    |> follow_instructions(knots, MapSet.put(MapSet.new(), {0, 0}))
  end

  defp follow_instructions([], knots, visited_points),
    do: MapSet.put(visited_points, List.last(knots))

  defp follow_instructions([head | tail], knots, visited_points) do
    [t | _rest] =
      knots =
      Enum.reduce(Enum.with_index(knots), [], fn
        {knot, 0}, knots ->
          [follow_command(head, knot) | knots]

        {knot, _i}, [prev_knot | knots] ->
          [follow_knot(knot, prev_knot), prev_knot] ++ knots
      end)

    follow_instructions(tail, Enum.reverse(knots), MapSet.put(visited_points, t))
  end

  defp follow_knot({x1, y1} = knot, {x2, y2}) when abs(x1 - x2) <= 1 and abs(y1 - y2) <= 1,
    do: knot

  defp follow_knot({x1, y1}, {x2, y2}) when x1 == x2 and y2 > y1, do: {x1, y1 + 1}
  defp follow_knot({x1, y1}, {x2, y2}) when x1 == x2 and y2 < y1, do: {x1, y1 - 1}
  defp follow_knot({x1, y1}, {x2, y2}) when y1 == y2 and x2 > x1, do: {x1 + 1, y1}
  defp follow_knot({x1, y1}, {x2, y2}) when y1 == y2 and x2 < x1, do: {x1 - 1, y1}
  defp follow_knot({x1, y1}, {x2, y2}) when y1 > y2 and x1 > x2, do: {x1 - 1, y1 - 1}
  defp follow_knot({x1, y1}, {x2, y2}) when y1 < y2 and x1 > x2, do: {x1 - 1, y1 + 1}
  defp follow_knot({x1, y1}, {x2, y2}) when y1 > y2 and x1 < x2, do: {x1 + 1, y1 - 1}
  defp follow_knot({x1, y1}, {x2, y2}) when y1 < y2 and x1 < x2, do: {x1 + 1, y1 + 1}

  defp follow_knot(knot, head_knot),
    do:
      raise("""
        Unknown follow knot.
        head: #{inspect(head_knot)}
        tail: #{inspect(knot)}
      """)

  defp follow_command("R", {x, y}), do: {x + 1, y}
  defp follow_command("L", {x, y}), do: {x - 1, y}
  defp follow_command("U", {x, y}), do: {x, y + 1}
  defp follow_command("D", {x, y}), do: {x, y - 1}

  defp map_instructions([], acc), do: Enum.reverse(acc)

  defp map_instructions([head | rest], acc) do
    [direction, steps] = String.split(head, " ")
    steps = String.to_integer(steps)
    new_steps = Enum.map(1..steps, fn _num -> direction end)

    map_instructions(rest, new_steps ++ acc)
  end
end
