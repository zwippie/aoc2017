defmodule AOC.Day5 do
  @moduledoc """
  How many steps to reach the exit?
  """

  def solve do
    execute(read_input(), 0, 0)
  end

  def execute(maze, at, count) do
    offset = Enum.at(maze, at)
    maze = List.update_at(maze, at, &(&1 + 1))
    cond do
      offset == nil -> count
      true -> execute(maze, at + offset, count + 1)
    end
  end

  def read_input do
    File.read!("priv/input/day5.txt")
    |> String.split(~r{\n}, trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule AOC.Day5b do
  def solve do
    execute(AOC.Day5.read_input(), 0, 0)
  end

  def execute(maze, at, count) do
    offset = Enum.at(maze, at)

    cond do
      offset == nil ->
        count
      offset >= 3 ->
        maze = List.update_at(maze, at, &(&1 - 1))
        execute(maze, at + offset, count + 1)
      true ->
        maze = List.update_at(maze, at, &(&1 + 1))
        execute(maze, at + offset, count + 1)
    end
  end
end
