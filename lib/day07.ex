defmodule Day07 do
  def part1 do
    input = File.read!("./inputs/day07.txt")

    input
    |> String.split("\n", trim: true)
    |> parse_fs()
    |> calculate_dir_size()
    |> elem(1)
    |> Enum.reject(fn {_name, size} -> size > 100_000 end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def part2 do
    input = File.read!("./inputs/day07.txt")

    {sum, dirs} =
      input
      |> String.split("\n", trim: true)
      |> parse_fs()
      |> calculate_dir_size()

    to_delete = 30_000_000 - (70_000_000 - sum)

    dirs
    |> Enum.map(&elem(&1, 1))
    |> Enum.reject(fn size -> size < to_delete end)
    |> Enum.min()
  end

  defp calculate_dir_size(fs) do
    fs
    |> Map.to_list()
    |> Enum.reject(&(elem(&1, 0) === :__size))
    |> Enum.reduce({fs.__size, []}, fn
      {dir_name, dir}, {acc, dirs} when is_map(dir) ->
        {sum, child_dirs} = calculate_dir_size(dir)
        {acc + sum, [{dir_name, sum} | child_dirs ++ dirs]}

      {_file_name, _size}, acc ->
        acc
    end)
  end

  defp parse_fs(commands, path \\ nil, fs \\ %{})
  defp parse_fs([], _cur_node, fs), do: fs

  defp parse_fs([_cmd | tail], nil, _fs),
    do: parse_fs(tail, ["/"], %{"/" => %{__size: 0}, __size: 0})

  defp parse_fs(["$ cd .." | tail], [_pwd | rest_path], fs), do: parse_fs(tail, rest_path, fs)

  defp parse_fs(["$ cd " <> new_path | tail], path, fs),
    do: parse_fs(tail, [new_path | path], fs)

  defp parse_fs(["$ ls" | tail], path, fs) do
    {children, tail} = Enum.split_while(tail, &(not String.starts_with?(&1, "$")))

    getter_path = Enum.reverse(path)

    cur_node = get_in(fs, getter_path)

    new_node =
      Enum.reduce(children, cur_node, fn
        "dir " <> dir_name, acc ->
          Map.put_new(acc, dir_name, %{__size: 0})

        line, acc ->
          [size, name] = String.split(line, " ")
          size = String.to_integer(size)

          if name in Map.keys(acc) do
            acc
          else
            acc
            |> Map.put(name, size)
            |> Map.update(:__size, size, &(&1 + size))
          end
      end)

    new_fs = put_in(fs, getter_path, new_node)
    parse_fs(tail, path, new_fs)
  end
end
