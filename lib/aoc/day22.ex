defmodule AOC.Day22 do
  @moduledoc """
  - If the current node is infected, it turns to its right. Otherwise, it turns to its left.
    (Turning is done in-place; the current node does not change.)
  - If the current node is clean, it becomes infected. Otherwise, it becomes cleaned.
    (This is done after the node is considered for the purposes of changing direction.)
  - The virus carrier moves forward one node in the direction it is facing.
  """

  @bursts 10_000

  def solve do
    input = read_input()
    {row, col} = center(input)

    next_state(input, row, col)
  end

  def next_state(matrix, row, col, dir \\ :up, bursts \\ 0, infections \\ 0)
  def next_state(_, _, _, _, @bursts, infections), do: infections
  def next_state(matrix, row, col, dir, bursts, infections) do
    # IO.inspect {matrix, row, col, dir, bursts, infections}

    dir = next_dir(matrix, row, col, dir)
    infections = case at(matrix, row, col) do
      0 -> infections + 1
      1 -> infections
    end
    matrix = invert(matrix, row, col)
    {matrix, row, col} = move_forward(matrix, row, col, dir)

    next_state(matrix, row, col, dir, bursts + 1, infections)
  end

  def move_forward(matrix, row, col, dir) do
    cond do
      dir == :up && row == 0 ->
        {prepend_row(matrix), row, col}
      dir == :up ->
        {matrix, row - 1, col}
      dir == :right && col == no_cols(matrix) - 1 ->
        {append_col(matrix), row, col + 1}
      dir == :right ->
        {matrix, row, col + 1}
      dir == :down && row == no_rows(matrix) - 1 ->
        {append_row(matrix), row + 1, col}
      dir == :down ->
        {matrix, row + 1, col}
      dir == :left && col == 0 ->
        {prepend_col(matrix), row, col}
      dir == :left ->
        {matrix, row, col - 1}
    end
  end

  def next_dir(matrix, row, col, dir) do
    case at(matrix, row, col) do
      0 -> turn_left(dir)
      1 -> turn_right(dir)
    end
  end

  def turn_left(:up), do: :left
  def turn_left(:right), do: :up
  def turn_left(:down), do: :right
  def turn_left(:left), do: :down

  def turn_right(:up), do: :right
  def turn_right(:right), do: :down
  def turn_right(:down), do: :left
  def turn_right(:left), do: :up

  def at(matrix, row, col) do
    matrix
    |> Enum.at(row)
    |> Enum.at(col)
  end

  def invert(matrix, row, col) do
    row_values =
      Enum.at(matrix, row)
      |> List.update_at(col, &invert/1)
    List.replace_at(matrix, row, row_values)
  end

  def invert(0), do: 1
  def invert(1), do: 0

  # MATRIX EXPANSION

  def no_rows(matrix), do: length(matrix)
  def no_cols(matrix), do: length(hd(matrix))

  def prepend_row(matrix) do
    len = matrix |> hd |> length
    [List.duplicate(0, len) | matrix]
  end

  def append_row(matrix) do
    len = matrix |> hd |> length
    matrix ++ [List.duplicate(0, len)]
  end

  def prepend_col(matrix) do
    Enum.map(matrix, & [0 | &1])
  end

  def append_col(matrix) do
    Enum.map(matrix, & &1 ++ [0])
  end

  # INPUT HANDLING

  def read_input do
    File.read!("priv/input/day22.txt")
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    line
    |> String.split("", trim: true)
    |> Enum.map(&zero_or_one/1)
  end

  def zero_or_one("."), do: 0
  def zero_or_one("#"), do: 1

  def center(matrix) do
    half = ((length(matrix) - 1) / 2) |> trunc
    {half, half}
  end
end
