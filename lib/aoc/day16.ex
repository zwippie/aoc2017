defmodule AOC.Day16 do
  def solve do
    read_input()
    |> run_program(init_memory())
    |> Enum.join("")
  end

  def run_program([], memory), do: memory
  def run_program([command | tail], memory) do
    run_program(tail, perform_command(command, memory))
  end

  def perform_command({:spin, x}, memory) do
    {first, last} = Enum.split(memory, 16 - x)
    last ++ first
  end

  def perform_command({:exchange, a, b}, memory) do
    val_a = Enum.at(memory, a)
    val_b = Enum.at(memory, b)
    memory
    |> List.replace_at(a, val_b)
    |> List.replace_at(b, val_a)
  end

  def perform_command({:partner, a, b}, memory) do
    loc_a = Enum.find_index(memory, & &1 == a)
    loc_b = Enum.find_index(memory, & &1 == b)
    memory
    |> List.replace_at(loc_a, b)
    |> List.replace_at(loc_b, a)
  end

  def init_memory do
    (0..15) |> Enum.map(& <<(&1 + ?a)>>)
  end

  def read_input do
    File.read!("priv/input/day16.txt")
    |> String.split(~r/,|\n/, trim: true)
    |> Enum.map(&to_command/1)
  end

  def to_command("s" <> x) do
    {:spin, String.to_integer(x)}
  end

  def to_command("x" <> swap) do
    [a, b] = Regex.run(~r/(\d+)\/(\d+)/, swap, capture: :all_but_first)
    {:exchange, String.to_integer(a), String.to_integer(b)}
  end

  def to_command("p" <> partners) do
    [a, b] = Regex.run(~r/(\w+)\/(\w+)/, partners, capture: :all_but_first)
    {:partner, a, b}
  end
end

defmodule AOC.Day16b do
  import AOC.Day16, only: [run_program: 2, read_input: 0]

  @limit 1_000_000_000
  @init_memory ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"]

  def solve do
    input = read_input()
    dupe_idx = find_first_dupe(input, @init_memory, 0)
    count = rem(@limit, dupe_idx)

    run(input, @init_memory, count)
    |> Enum.join("")
  end

  def find_first_dupe(_, memory, count) when memory == @init_memory and count > 0, do: count
  def find_first_dupe(input, memory, count) do
    find_first_dupe(input, run_program(input, memory), count + 1)
  end

  def run(_, memory, 0), do: memory
  def run(input, memory, count) do
    run(input, run_program(input, memory), count - 1)
  end
end
