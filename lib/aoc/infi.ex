defmodule AOC.Infi do
  @moduledoc """
  Sponsor puzzle: https://aoc.infi.nl/
  """

  import Mogrify

  def solve do
    {robots, moves} = read_input()
    img =
      %Mogrify.Image{path: "test.png", ext: "png"}
      |> custom("size", "400x400")
      |> canvas("white")
      |> custom("stroke", "black")
      |> custom("fill", "black")

    perform_moves(robots, moves, 0, [])
    |> draw_image(img)
    |> create(path: ".")
  end

  def draw_image([_], img), do: img
  def draw_image(moves, img) when length(moves) < 5080, do: img
  def draw_image([head | tail], img) do
    # img =
    #   head
    #   |> Enum.reduce(img, fn {x, y}, acc ->
    #     draw_point(acc, x * 8 + 16, y * 8 + 16)
    #   end)

    moves = Enum.zip(head, hd(tail))
    img =
      moves
      |> Enum.reduce(img, fn {{x1, y1}, {x2, y2}}, acc ->
        draw_line(acc, x1 * 8 + 16, y1 * 8 + 16, x2 * 8 + 16, y2 * 8 + 16)
      end)
    draw_image(tail, img)
  end

  def draw_point(img, x1, y1) do
    img
    |> custom("draw", "point #{to_string(:io_lib.format("~g,~g", [x1/1, y1/1]))}")
  end

  def draw_line(img, x1, y1, x2, y2) do
    img
    |> custom("draw", "line #{to_string(:io_lib.format("~g,~g ~g,~g", [x1/1, y1/1, x2/1, y2/1]))}")
  end

  def perform_moves(_, [], errors, paths) do
    # IO.inspect paths
    IO.puts "There were #{errors} errors during #{length(paths)} moves."
    paths
    |> Enum.reverse
  end
  def perform_moves(robots, moves, errors, paths) do
    {new_moves, moves} = Enum.split(moves, length(robots))
    robots =
      robots
      |> Enum.zip(new_moves)
      |> Enum.map(&move_robot/1)
    errors = cond do
      has_duplicates(robots) -> errors + 1
      true -> errors
    end
    perform_moves(robots, moves, errors, [robots | paths])
  end

  def has_duplicates(robots) do
    length(Enum.uniq(robots)) != length(robots)
  end

  def move_robot({{rx, ry}, {x, y}}) do
    {rx + x, ry + y}
  end

  def read_input do
    File.read!("priv/input/infi.txt")
    |> String.split(~r/\n/, trim: true)
    |> hd
    |> parse_input
  end

  def parse_input(input) do
    robots =
      Regex.scan(~r/\[(-?\d+),(-?\d+)\]/, input, capture: :all_but_first)
      |> Enum.map(&parse_pair/1)
    moves =
      Regex.scan(~r/\((-?\d+),(-?\d+)\)/, input, capture: :all_but_first)
      |> Enum.map(&parse_pair/1)
    {robots, moves}
  end

  def parse_pair([a, b]) do
    {String.to_integer(a), String.to_integer(b)}
  end
end
