defmodule AOC.Day10 do
  def solve do
    read_input()
    |> next_state(initial_state())
    |> Enum.take(2)
    |> Enum.reduce(&Kernel.*/2)
  end

  def next_state(lengths, state, pos \\ 0, skip_size \\ 0)
  def next_state([], state, _pos, _skip_size), do: state
  def next_state([head | tail], state, pos, skip_size) do
    state = wrapped_reverse_slice(state, pos, head)
    pos = rem(pos + head + skip_size, length(state))
    next_state(tail, state, pos, skip_size + 1)
  end

  def wrapped_reverse_slice(state, start, count) when start + count <= length(state) do
    Enum.reverse_slice(state, start, count)
  end

  def wrapped_reverse_slice(state, start, count) do
    end_length = length(state) - start
    start_length = count - end_length
    to_reverse = Enum.slice(state, start, end_length) ++ Enum.slice(state, 0, start_length)
    middle = Enum.slice(state, start_length, length(state) - count)
    reversed = Enum.reverse(to_reverse)
    {new_end, new_start} = Enum.split(reversed, end_length)
    new_start ++ middle ++ new_end
  end

  def initial_state do
    Enum.to_list(0..255)
  end

  def read_input do
    File.read!("priv/input/day10.txt")
    |> String.split(~r{\n}, trim: true)
    |> hd
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule AOC.Day10b do
  require Bitwise
  import AOC.Day10, only: [wrapped_reverse_slice: 3, initial_state: 0]

  @suffix <<17,31,73,47,23>>

  def solve do
    knot_hash read_input()
  end

  def knot_hash(str) do
    str
    |> Kernel.<>(@suffix)
    |> to_charlist
    |> multiple_rounds(initial_state(), 0, 0, 64)
    |> Enum.chunk_every(16)
    |> Enum.map(&xored/1)
    |> to_hex
  end

  def to_hex(list) do
    list
    |> Enum.map(& Integer.to_string(&1, 16))
    |> Enum.map(& String.pad_leading(&1, 2, "0"))
    |> Enum.join("")
    |> String.downcase
  end

  def xored(list) do
    Enum.reduce(list, & Bitwise.bxor(&1, &2))
  end

  def multiple_rounds(_lengths, state, _pos, _skip_size, 0), do: state
  def multiple_rounds(lengths, state, pos, skip_size, rounds) do
    {state, pos, skip_size} = next_state(lengths, state, pos, skip_size)
    multiple_rounds(lengths, state, pos, skip_size, rounds - 1)
  end

  def next_state(lengths, state, pos \\ 0, skip_size \\ 0)
  def next_state([], state, pos, skip_size), do: {state, pos, skip_size}
  def next_state([head | tail], state, pos, skip_size) do
    state = wrapped_reverse_slice(state, pos, head)
    pos = rem(pos + head + skip_size, length(state))
    next_state(tail, state, pos, skip_size + 1)
  end

  def read_input do
    File.read!("priv/input/day10.txt")
    |> String.split(~r{\n}, trim: true)
    |> hd
  end
end
