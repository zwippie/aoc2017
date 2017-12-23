defmodule AOC.Day22b do
  @moduledoc """
  - Clean nodes become weakened.
  - Weakened nodes become infected.
  - Infected nodes become flagged.
  - Flagged nodes become clean.

  - Decide which way to turn based on the current node:
    - If it is clean, it turns left.
    - If it is weakened, it does not turn, and will continue moving in the same direction.
    - If it is infected, it turns right.
    - If it is flagged, it reverses direction, and will go back the way it came.
  - Modify the state of the current node, as described above.
  - The virus carrier moves forward one node in the direction it is facing.
  """

  @bursts 10_000_000

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
      :weakened -> infections + 1
      _ -> infections
    end
    matrix = process_node(matrix, row, col)
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
      :clean -> turn_left(dir)
      :weakened -> dir
      :infected -> turn_right(dir)
      :flagged -> dir |> turn_right |> turn_right
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

  def process_node(matrix, row, col) do
    row_values =
      Enum.at(matrix, row)
      |> List.update_at(col, &process_node/1)
    List.replace_at(matrix, row, row_values)
  end

  def process_node(:clean), do: :weakened
  def process_node(:weakened), do: :infected
  def process_node(:infected), do: :flagged
  def process_node(:flagged), do: :clean

  # MATRIX EXPANSION

  def no_rows(matrix), do: length(matrix)
  def no_cols(matrix), do: length(hd(matrix))

  def prepend_row(matrix) do
    len = matrix |> hd |> length
    [List.duplicate(:clean, len) | matrix]
  end

  def append_row(matrix) do
    len = matrix |> hd |> length
    matrix ++ [List.duplicate(:clean, len)]
  end

  def prepend_col(matrix) do
    Enum.map(matrix, & [:clean | &1])
  end

  def append_col(matrix) do
    Enum.map(matrix, & &1 ++ [:clean])
  end

  def read_input do
    File.read!("priv/input/day22.txt")
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&parse_line/1)
  end

  # INPUT HANDLING

  def parse_line(line) do
    line
    |> String.split("", trim: true)
    |> Enum.map(&zero_or_one/1)
  end

  def zero_or_one("."), do: :clean
  def zero_or_one("#"), do: :infected

  def center(matrix) do
    half = ((length(matrix) - 1) / 2) |> trunc
    {half, half}
  end
end
