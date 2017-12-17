defmodule AOC.Day11 do
  def solve do
    read_input()
    |> perform_moves({0,0})
    |> Tuple.to_list
    |> Enum.map(&abs/1)
    |> Enum.sum
  end

  def perform_moves([], pos), do: pos
  def perform_moves([head | tail], {x, y}) do
    new_pos =
      case head do
        :n  -> {x,     y + 1}
        :ne -> {x + 1, y}
        :se -> {x + 1, y - 1}
        :s  -> {x,     y - 1}
        :sw -> {x - 1, y}
        :nw -> {x - 1, y + 1}
      end
    perform_moves(tail, new_pos)
  end

  def read_input do
    File.read!("priv/input/day11.txt")
    |> String.split(~r{\n}, trim: true)
    |> hd
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_atom/1)
  end
end

defmodule AOC.Day11b do
  def solve do
    AOC.Day11.read_input()
    |> perform_moves({0,0}, 0)
  end

  def perform_moves([], _pos, max), do: max
  def perform_moves([head | tail], {x, y}, max) do
    {x, y} =
      case head do
        :n  -> {x,     y + 1}
        :ne -> {x + 1, y}
        :se -> {x + 1, y - 1}
        :s  -> {x,     y - 1}
        :sw -> {x - 1, y}
        :nw -> {x - 1, y + 1}
      end
    dist = abs(x) + abs(y)
    max = if dist > max, do: dist, else: max
    perform_moves(tail, {x, y}, max)
  end
end
