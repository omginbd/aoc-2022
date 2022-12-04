defmodule Day04 do
  def p1 do
    input = File.read!("./inputs/day04.txt")

    input
    |> String.split("\n", trim: true)
    |> Enum.filter(fn elves ->
      [e1_lower, e1_upper, e2_lower, e2_upper] =
        ~r/(\d+)-(\d+),(\d+)-(\d+)/
        |> Regex.run(elves)
        |> then(fn [_hd | tl] -> Enum.map(tl, &String.to_integer/1) end)

      overlap? =
        (e1_lower <= e2_lower and e1_upper >= e2_upper) or
          (e2_lower <= e1_lower and e2_upper >= e1_upper)

      overlap?
    end)
    |> Enum.count()
  end

  def p2 do
    input = File.read!("./inputs/day04.txt")

    input
    |> String.split("\n", trim: true)
    |> Enum.filter(fn elves ->
      [e1_lower, e1_upper, e2_lower, e2_upper] =
        ~r/(\d+)-(\d+),(\d+)-(\d+)/
        |> Regex.run(elves)
        |> then(fn [_hd | tl] -> Enum.map(tl, &String.to_integer/1) end)

      not Range.disjoint?(e1_lower..e1_upper, e2_lower..e2_upper)
    end)
    |> Enum.count()
  end
end
