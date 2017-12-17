defmodule AOC.Day9 do
  def solve do
    read_input()
    |> parse(0, 0)
  end

  def parse([], 0, score), do: score
  def parse([head | tail], level, score) do
    case head do
      "{" -> parse(tail, level + 1, score)
      "}" -> parse(tail, level - 1, score + level)
      "<" -> parse_garbage(tail, level, score)
      _   -> parse(tail, level, score)
    end
  end

  def parse_garbage([head | tail], level, score) do
    case head do
      ">" -> parse(tail, level, score)
      "!" -> parse_garbage(tl(tail), level, score)
      _   -> parse_garbage(tail, level, score)
    end
  end

  def read_input do
    File.read!("priv/input/day9.txt")
    |> String.split(~r{\n}, trim: true)
    |> hd
    |> String.split("", trim: true)
  end
end

defmodule AOC.Day9b do
  def solve do
    AOC.Day9.read_input()
    |> parse(0, 0)
  end

  def parse([], 0, score), do: score
  def parse([head | tail], level, score) do
    case head do
      "{" -> parse(tail, level + 1, score)
      "}" -> parse(tail, level - 1, score)
      "<" -> parse_garbage(tail, level, score)
      _   -> parse(tail, level, score)
    end
  end

  def parse_garbage([head | tail], level, score) do
    case head do
      ">" -> parse(tail, level, score)
      "!" -> parse_garbage(tl(tail), level, score)
      _   -> parse_garbage(tail, level, score + 1)
    end
  end
end
