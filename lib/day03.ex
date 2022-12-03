defmodule Day03 do
  def p1 do
    input = File.read!("./inputs/day03.txt")

    input
    |> String.split("\n", trim: true)
    |> Enum.map(&find_common_letter/1)
    |> Enum.map(&to_priority/1)
    |> Enum.sum()
  end

  def p2 do
    input = File.read!("./inputs/day03.txt")

    input
    |> String.split("\n", trim: true)
    |> Enum.chunk_every(3)
    |> Enum.map(&find_common_letter/1)
    |> Enum.map(&to_priority/1)
    |> Enum.sum()
  end

  defp find_common_letter(elves) when is_list(elves) do
    [e1, e2, e3] =
      elves
      |> Enum.map(&(String.graphemes(&1) |> Enum.into(MapSet.new())))

    MapSet.intersection(e1, e2)
    |> MapSet.intersection(e3)
    |> MapSet.to_list()
    |> List.first()
  end

  defp find_common_letter(sack) when is_binary(sack) do
    sack
    |> String.split_at(div(String.length(sack), 2))
    |> then(fn {left, right} ->
      Enum.into(String.graphemes(left), MapSet.new())
      |> MapSet.intersection(Enum.into(String.graphemes(right), MapSet.new()))
    end)
    |> MapSet.to_list()
    |> List.first()
  end

  defp to_priority(letter) do
    as_char =
      letter
      |> String.to_charlist()
      |> List.first()

    if as_char < ?a do
      as_char - ?A + 27
    else
      as_char - ?a + 1
    end
  end
end
