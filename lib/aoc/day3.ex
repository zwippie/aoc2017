defmodule AOC.Day3 do
  @moduledoc """
  --- Day 3: Spiral Memory ---
  You come across an experimental new kind of memory stored on an infinite two-dimensional grid.

  Each square on the grid is allocated in a spiral pattern starting at a location marked 1 and
  then counting up while spiraling outward. For example, the first few squares are allocated like this:

  17  16  15  14  13
  18   5   4   3  12
  19   6   1   2  11
  20   7   8   9  10
  21  22  23---> ...

  While this is very space-efficient (no squares are skipped), requested data must be carried
  back to square 1 (the location of the only access port for this memory system) by programs
  that can only move up, down, left, or right. They always take the shortest path:
  the Manhattan Distance between the location of the data and square 1.

  For example:

  Data from square 1 is carried 0 steps, since it's at the access port.
  Data from square 12 is carried 3 steps, such as: down, left, left.
  Data from square 23 is carried only 2 steps: up twice.
  Data from square 1024 must be carried 31 steps.

  How many steps are required to carry the data from the square identified in your puzzle
  input all the way to the access port?

  Your puzzle input is 289326.
  """

  require Integer

  @input 289326

  def solve do
    closest_sqrt = find_closest_odd_sqrt(@input)
    cs_squared = closest_sqrt |> :math.pow(2) |> trunc
    remaining = @input - cs_squared
    side_length = closest_sqrt + 2

    IO.inspect {@input, closest_sqrt, cs_squared, remaining, side_length}
    IO.inspect {div(remaining, side_length), rem(remaining, side_length)}

    # Lucky this works for the input case!
    abs(div(remaining, side_length)) + abs(rem(remaining, side_length))
  end

  def find_closest_odd_sqrt(val) do
    closest_sqrt = :math.sqrt(val) |> trunc
    cond do
      Integer.is_even(closest_sqrt) -> closest_sqrt - 1
      true -> closest_sqrt
    end
  end
end

defmodule AOC.Day3b do
  @moduledoc """
  --- Part Two ---
  As a stress test on the system, the programs here clear the grid and then store
  the value 1 in square 1. Then, in the same allocation order as shown above, they store
  the sum of the values in all adjacent squares, including diagonals.

  So, the first few squares' values are chosen as follows:

  Square 1 starts with the value 1.
  Square 2 has only one adjacent filled square (with value 1), so it also stores 1.
  Square 3 has both of the above squares as neighbors and stores the sum of their values, 2.
  Square 4 has all three of the aforementioned squares as neighbors and
  stores the sum of their values, 4.
  Square 5 only has the first and fourth squares as neighbors, so it gets the value 5.

  Once a square is written, its value does not change. Therefore, the first
  few squares would receive the following values:

  147  142  133  122   59
  304    5    4    2   57
  330   10    1    1   54
  351   11   23   25   26
  362  747  806--->   ...

  What is the first value written that is larger than your puzzle input?
  """

  @input 289326

  def solve do
    find_greater_value([{0, 0, 1}], 1)
  end

  def find_greater_value(spiral, level) do
    spiral = next_level(spiral, level)
    value = spiral |> hd |> elem(2)
    case value > @input do
      true -> value
      false -> find_greater_value(spiral, level + 1)
    end
  end

  def next_level(spiral, level) do
    cells_at_level(level)
    |> Enum.reduce_while(spiral, fn({row, col}, acc) ->
      sum = sum_of_neighbours(acc, row, col)
      action = if sum > @input, do: :halt, else: :cont
      {action, [{row, col, sum_of_neighbours(acc, row, col)} | acc]}
    end)
  end

  def sum_of_neighbours(cells, row, col) do
    [{row - 1, col - 1}, {row - 1, col}, {row - 1, col + 1},
     {row,     col - 1},                 {row,     col + 1},
     {row + 1, col - 1}, {row + 1, col}, {row + 1, col + 1}]
    |> Enum.map(fn {r, c} -> value(cells, r, c) end)
    |> Enum.sum
  end

  def value(cells, row, col) do
    cells
    |> Enum.find({0, 0, 0}, fn {r, c, _val} -> r == row && c == col end)
    |> elem(2)
  end

  def start_at(level, :right),  do: {1 - level, level}
  def start_at(level, :top),    do: {level, level - 1}
  def start_at(level, :left),   do: {level - 1, -level}
  def start_at(level, :bottom), do: {-level, 1 - level}

  def start_ats(level) do
    [start_at(level, :right),
     start_at(level, :top),
     start_at(level, :left),
     start_at(level, :bottom)]
  end

  def cells_at_level(0), do: [{0, 0}]
  def cells_at_level(level) do
    add_side(level, :right) ++
    add_side(level, :top) ++
    add_side(level, :left) ++
    add_side(level, :bottom)
  end

  def add_side(level, :right) do
    {row, col} = start_at(level, :right)
    Enum.map((0..level * 2 - 1), fn idx -> {row + idx, col} end)
  end

  def add_side(level, :top) do
    {row, col} = start_at(level, :top)
    Enum.map((0..level * 2 - 1), fn idx -> {row, col - idx} end)
  end

  def add_side(level, :left) do
    {row, col} = start_at(level, :left)
    Enum.map((0..level * 2 - 1), fn idx -> {row - idx, col} end)
  end

  def add_side(level, :bottom) do
    {row, col} = start_at(level, :bottom)
    Enum.map((0..level * 2 - 1), fn idx -> {row, col + idx} end)
  end
end
