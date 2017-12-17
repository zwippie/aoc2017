defmodule AOC.Day14 do
  import AOC.Day10b, only: [knot_hash: 1]

  @input "nbysizxe"

  def solve do
    (0..127)
    |> Enum.map(&row_hashes/1)
    |> Enum.map(&no_ones/1)
    |> Enum.sum
  end

  def row_hashes(row) do
    @input
    |> Kernel.<>("-")
    |> Kernel.<>(Integer.to_string(row))
    |> knot_hash()
    |> to_bitstring
  end

  def to_bitstring(hex_string) do
    hex_string
    |> String.split("", trim: true)
    |> Enum.map(& String.to_integer(&1, 16))
    |> Enum.map(& Integer.to_string(&1, 2))
    |> Enum.map(& String.pad_leading(&1, 4, "0"))
    |> Enum.join("")
  end

  def no_ones(bit_string) do
    bit_string
    |> String.split("", trim: true)
    |> Enum.count(& &1 == "1")
  end
end

defmodule AOC.Day14b do
  def solve do
    (0..127)
    |> Enum.map(&AOC.Day14.row_hashes/1)
    |> Enum.map(& String.split(&1, "", trim: true))
    |> Enum.map(&to_integers/1)
    |> fill_regions(0, 0, 2)
    |> Kernel.-(2)
  end

  def fill_regions(_memory, 128, 0, color), do: color
  def fill_regions(memory, row, col, color) do
    {memory, color} =
      case at(memory, row, col) do
        1 -> {floodfill(memory, row, col, color), color + 1}
        _ -> {memory, color}
      end
    {row, col} = next_row_col(row, col)
    fill_regions(memory, row, col, color)
  end

  def floodfill(memory, row, _, _) when row < 0 or row > 127, do: memory
  def floodfill(memory, _, col, _) when col < 0 or col > 127, do: memory
  def floodfill(memory, row, col, color) do
    case at(memory, row, col) do
      1 ->
        memory
        |> set(row, col, color)
        |> floodfill(row - 1, col, color)
        |> floodfill(row + 1, col, color)
        |> floodfill(row, col - 1, color)
        |> floodfill(row, col + 1, color)
      _ ->
        memory
    end
  end

  def at(data, row, col) do
    data
    |> Enum.at(row, [])
    |> Enum.at(col)
  end

  def set(data, row, col, value) do
    row_data = Enum.at(data, row)
    row_data = List.replace_at(row_data, col, value)
    List.replace_at(data, row, row_data)
  end

  def next_row_col(row, col) do
    col = col + 1
    cond do
      col > 127 -> {row + 1, 0}
      true -> {row, col}
    end
  end

  def to_integers(list) do
    Enum.map(list, &String.to_integer/1)
  end
end
