defmodule Day08 do
  def part1 do
    input = File.read!("./inputs/day08.txt")

    input
    |> build_tree_map()
    |> count_visible_trees()
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2 do
    input = File.read!("./inputs/day08.txt")

    input
    |> build_tree_map()
    |> find_best_tree()
    |> then(fn {score, {x, y}} -> "#{inspect({x, y})}: #{score}" end)
  end

  defp find_best_tree(tree_map) do
    max_x = tree_map.__width - 1
    max_y = tree_map.__height - 1

    tree_map
    |> Map.keys()
    |> Enum.reject(&(&1 in [:__height, :__width]))
    |> Enum.reduce({-1, {-1, -1}}, fn {x, y}, {best_so_far, _best_coord} = acc ->
      scenic_score =
        [up: y..0, left: x..0, down: y..max_y, right: x..max_x]
        |> Enum.map(fn
          {_dir, start..start} ->
            0

          {dir, range} when dir in [:left, :right] ->
            Enum.reduce_while(range, 0, fn
              ^x, count ->
                {:cont, count}

              x1, count ->
                if tree_map[{x1, y}] < tree_map[{x, y}] do
                  {:cont, count + 1}
                else
                  {:halt, count + 1}
                end
            end)

          {dir, range} when dir in [:up, :down] ->
            Enum.reduce_while(range, 0, fn
              ^y, count ->
                {:cont, count}

              y1, count ->
                if tree_map[{x, y1}] < tree_map[{x, y}] do
                  {:cont, count + 1}
                else
                  {:halt, count + 1}
                end
            end)
        end)
        |> Enum.reduce(1, &(&1 * &2))

      if scenic_score > best_so_far do
        {scenic_score, {x, y}}
      else
        acc
      end
    end)
  end

  defp build_tree_map(input) do
    rows =
      input
      |> String.split("\n", trim: true)

    width = rows |> List.first() |> String.length()
    height = length(rows)

    rows
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {tree, x}, ac ->
        Map.put(ac, {x, y}, String.to_integer(tree))
      end)
    end)
    |> Map.put(:__height, height)
    |> Map.put(:__width, width)
  end

  defp count_visible_trees(tree_map) do
    by_col =
      for x <- 0..(tree_map.__width - 1) do
        down =
          Enum.reduce(0..(tree_map.__height - 1), {-1, []}, fn y,
                                                               {tallest_so_far, visible_trees} =
                                                                 acc ->
            if tree_map[{x, y}] > tallest_so_far do
              {tree_map[{x, y}], [{x, y} | visible_trees]}
            else
              acc
            end
          end)
          |> elem(1)

        up =
          Enum.reduce((tree_map.__height - 1)..0, {-1, []}, fn y,
                                                               {tallest_so_far, visible_trees} =
                                                                 acc ->
            if tree_map[{x, y}] > tallest_so_far do
              {tree_map[{x, y}], [{x, y} | visible_trees]}
            else
              acc
            end
          end)
          |> elem(1)

        Enum.uniq(down ++ up)
      end
      |> List.flatten()

    by_row =
      for y <- 0..(tree_map.__height - 1) do
        down =
          Enum.reduce(0..(tree_map.__width - 1), {-1, []}, fn x,
                                                              {tallest_so_far, visible_trees} =
                                                                acc ->
            if tree_map[{x, y}] > tallest_so_far do
              {tree_map[{x, y}], [{x, y} | visible_trees]}
            else
              acc
            end
          end)
          |> elem(1)

        up =
          Enum.reduce((tree_map.__width - 1)..0, {-1, []}, fn x,
                                                              {tallest_so_far, visible_trees} =
                                                                acc ->
            if tree_map[{x, y}] > tallest_so_far do
              {tree_map[{x, y}], [{x, y} | visible_trees]}
            else
              acc
            end
          end)
          |> elem(1)

        Enum.uniq(down ++ up)
      end
      |> List.flatten()

    by_col ++ by_row
  end
end
