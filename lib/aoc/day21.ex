defmodule AOC.Day21 do
  @start ".#./..#/###"
  @cycles 2

  def solve do
    read_input()
    |> Enum.flat_map(fn [k, v] ->
      variants(k) |> Enum.map(& {&1, v})
    end)
    |> Map.new
    |> enhance(string_to_list(@start), @cycles)
  end

  def enhance(_, grid, 0) do
    grid
  end

  def enhance(dict, grid, count) when rem(length(grid), 2) == 0 do
    grid = partition(grid, 2)

    dict
    |> Map.fetch!(list_to_string(grid))
    |> string_to_list
  end

  def enhance(dict, grid, count) when rem(length(grid), 3) == 0 do
    grid = partition(grid, 3)

    dict
    |> Map.fetch!(list_to_string(grid))
    |> string_to_list
  end

  def partition(grid, size) do
    grid
    |> Enum.chunk_every(size)
    |> Enum.map(fn rows ->
      partition_rows(rows, [])
    end)
    |> hd
  end


  def partition_rows([[], []], acc), do: acc
  def partition_rows([a, b], acc) do
    {na, a} = Enum.split(a, 2)
    {nb, b} = Enum.split(b, 2)
    partition_rows([a, b], acc ++ [[na, nb]])
  end

  def partition_rows([[], [], []], acc), do: acc
  def partition_rows([a, b, c], acc) do
    {na, a} = Enum.split(a, 3)
    {nb, b} = Enum.split(b, 3)
    {nc, c} = Enum.split(c, 3)
    partition_rows([a, b, c], acc ++ [na, nb, nc])
  end


  @doc """
  All string variants (rotated and/or flipped) of a square (as list)
  """
  def variants(square) do
    [ square,
      square |> rotate_cw,
      square |> rotate_cw |> rotate_cw,
      square |> rotate_cw |> rotate_cw |> rotate_cw]
    |> Enum.flat_map(fn sq ->
      [sq, flip_h(sq), flip_v(sq), sq |> flip_h |> flip_v]
    end)
    |> Enum.uniq
    |> Enum.map(&list_to_string/1)
  end

  def string_to_list(square) do
    square
    |> String.split("/")
    |> Enum.map(& String.split(&1, "", trim: true))
  end

  def list_to_string([a, b]) do
    Enum.join(a, "") <> "/" <> Enum.join(b, "")
  end

  def list_to_string([a, b, c]) do
    Enum.join(a, "") <> "/" <> Enum.join(b, "") <> "/" <> Enum.join(c, "")
  end

  def rotate_cw([[a, b], [c, d]]) do
    [[c, a], [d, b]]
  end

  def rotate_cw([[a, b, c], [d, e, f], [g, h, i]]) do
    [[g, d, a], [h, e, b], [i, f, c]]
  end

  def flip_h([[a, b], [c, d]]) do
    [[c, a], [b, d]]
  end

  def flip_h([[a, b, c], [d, e, f], [g, h, i]]) do
    [[c, b, a], [f, e, d], [i, h, g]]
  end

  def flip_v([[a, b], [c, d]]) do
    [[d, c], [a, b]]
  end

  def flip_v([[a, b, c], [d, e, f], [g, h, i]]) do
    [[g, d, a], [h, e, b], [i, f, c]]
  end

  def read_input do
    Regex.scan(
      ~r/(.+) \=\> (.+)/,
      File.read!("priv/input/day21_example.txt"),
      capture: :all_but_first)
    |> Enum.map(&parse_line/1)
  end

  def parse_line([k, v]), do: [string_to_list(k), v] # string_to_list(v)]
end
