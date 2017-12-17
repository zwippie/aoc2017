defmodule AOC.Day12 do
  def solve do
    read_input()
    |> add_programs([0])
    |> length
  end

  def add_programs(programs, to_check, acc \\ [])
  def add_programs(_, [], acc), do: acc
  def add_programs(programs, [head | tail], acc) do
    cond do
      head in acc ->
        add_programs(programs, tail, acc)
      true ->
        add_programs(programs, Enum.at(programs, head) ++ tail, [head | acc])
    end
  end

  def read_input do
    File.read!("priv/input/day12.txt")
    |> String.split(~r{\n}, trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    String.split(line, " <-> ")
    |> Enum.at(1)
    |> String.split(", ")
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule AOC.Day12b do
  def solve do
    AOC.Day12.read_input()
    |> find_next_group
    |> length
  end

  def find_next_group(programs, groups \\ []) do
    start_idx =
      (0..length(programs) - 1 |> Enum.to_list)
      |> Kernel.--(List.flatten(groups))
      |> Enum.at(0, nil)
    case start_idx do
      nil ->
        groups
      _ ->
        new_group = AOC.Day12.add_programs(programs, [start_idx])
        find_next_group(programs, [new_group | groups])
    end
  end
end
