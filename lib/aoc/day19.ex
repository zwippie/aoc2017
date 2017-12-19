defmodule AOC.Day19 do
  def solve do
    input = read_input()
    col = find_start(input)

    crawl_path(input, 0, col, :down, [], 0)
  end

  def crawl_path(_input, _, _, :halt, word, count) do
    {count, Enum.reverse(word) |> Enum.join("")}
  end

  def crawl_path(input, row, col, dir, word, count) do
    {row, col} = forward(row, col, dir)
    char = at(input, row, col)
    cond do
      char == "+" ->
        dir = turn(input, row, col, dir)
        crawl_path(input, row, col, dir, word, count + 1)
      String.match?(char, ~r/[A-Z]/) ->
        crawl_path(input, row, col, dir, [char | word], count + 1)
      char == " " ->
        crawl_path(input, row, col, :halt, word, count + 1)
      char == nil ->
        raise("out of bounds")
      true ->
        crawl_path(input, row, col, dir, word, count + 1)
    end
  end

  def turn(input, row, col, dir) do
    cond do
      dir != :down    && at(input, row - 1, col) == "|" -> :up
      dir != :left && at(input, row, col + 1) == "-" -> :right
      dir != :up  && at(input, row + 1, col) == "|" -> :down
      dir != :right  && at(input, row, col - 1) == "-" -> :left
      true -> raise("invalid turn")
    end
  end

  def forward(row, col, dir) do
    cond do
      dir == :up    -> {row - 1, col}
      dir == :right -> {row, col + 1}
      dir == :down  -> {row + 1, col}
      dir == :left  -> {row, col - 1}
    end
  end

  def at(input, row, col) do
    input
    |> Enum.at(row, "")
    |> String.at(col)
  end

  def find_start(input) do
    Regex.run(~r/\|/, hd(input), return: :index)
    |> hd
    |> elem(0)
  end

  def read_input do
    File.read!("priv/input/day19.txt")
    |> String.split(~r/\n/, trim: true)
  end
end
