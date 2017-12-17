defmodule AOC.Day6 do
  @moduledoc """
  Memory bank block reallocation.
  """

  def solve do
    read_input()
    |> reallocate([], 0)
  end

  def reallocate(memory, previous, count) do
    {max, idx} = max_with_index(memory)
    memory = List.replace_at(memory, idx, 0)
    idx = rem(idx + 1, length(memory))
    memory = redistribute(memory, idx, max)
    if memory in previous do
      count + 1
    else
      reallocate(memory, [memory | previous], count + 1)
    end
  end

  def redistribute(memory, _, 0), do: memory
  def redistribute(memory, idx, left) do
    memory = List.update_at(memory, idx, & &1 + 1)
    idx = rem(idx + 1, length(memory))
    redistribute(memory, idx, left - 1)
  end

  def max_with_index(memory) do
    max = Enum.max(memory)
    {max, Enum.find_index(memory, & &1 == max)}
  end

  def read_input do
    File.read!("priv/input/day6.txt")
    |> String.split(~r{\n}, trim: true)
    |> Enum.flat_map(&parse_line/1)
  end

  def parse_line(line) do
    String.split(line, ~r{\s}, trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule AOC.Day6b do
  import AOC.Day6, except: [solve: 0, reallocate: 3]

  def solve do
    read_input()
    |> reallocate([])
  end

  def reallocate(memory, previous) do
    {max, idx} = max_with_index(memory)
    memory = List.replace_at(memory, idx, 0)
    idx = rem(idx + 1, length(memory))
    memory = redistribute(memory, idx, max)
    if memory in previous do
      Enum.find_index(previous, & &1 == memory) + 1
    else
      reallocate(memory, [memory | previous])
    end
  end
end
