defmodule AOC.Day2 do
  def solve do
    read_input()
    |> Enum.map(&min_and_max_diff/1)
    |> Enum.sum
  end

  def min_and_max_diff(line) do
    {min, max} = Enum.min_max(line)
    max - min
  end

  def read_input do
    File.read!("priv/input/day2.txt")
    |> String.split(~r{\n}, trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    line
    |> String.split( ~r{\s}, trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule AOC.Day2b do
  def solve do
    AOC.Day2.read_input()
    |> Enum.flat_map(&even_dividers_result/1)
    |> Enum.sum
  end

  def even_dividers_result(line) do
    for val1 <- line,
        val2 <- line,
        val1 > val2,
        rem(val1, val2) == 0,
        do: div(val1, val2)
  end
end
