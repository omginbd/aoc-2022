defmodule Day02 do
  def p1 do
    input = File.read!("./inputs/day02.txt")

    String.split(input, "\n", trim: true)
    |> Enum.map(&calculate_score/1)
    |> Enum.sum()
  end

  def p2 do
    input = File.read!("./inputs/day02.txt")

    # input = """
    # A Y
    # B X
    # C Z
    # """

    String.split(input, "\n", trim: true)
    |> Enum.map(&calculate_outcome/1)
    |> Enum.sum()
  end

  defp calculate_outcome("A X"), do: 3
  defp calculate_outcome("A Y"), do: 4
  defp calculate_outcome("A Z"), do: 8
  defp calculate_outcome("B X"), do: 1
  defp calculate_outcome("B Y"), do: 5
  defp calculate_outcome("B Z"), do: 9
  defp calculate_outcome("C X"), do: 2
  defp calculate_outcome("C Y"), do: 6
  defp calculate_outcome("C Z"), do: 7

  defp calculate_score("A X"), do: 4
  defp calculate_score("A Y"), do: 8
  defp calculate_score("A Z"), do: 3
  defp calculate_score("B X"), do: 1
  defp calculate_score("B Y"), do: 5
  defp calculate_score("B Z"), do: 9
  defp calculate_score("C X"), do: 7
  defp calculate_score("C Y"), do: 2
  defp calculate_score("C Z"), do: 6
end
