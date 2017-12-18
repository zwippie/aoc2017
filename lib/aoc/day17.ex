defmodule AOC.Day17 do
  @step_size 363
  @stop_at 2017

  def solve do
    next_state([0], 0, 0)
  end

  def next_state(state, pos, @stop_at), do: Enum.at(state, pos + 1)
  def next_state(state, pos, count) do
    circular_pos = rem(pos + @step_size, length(state))
    state = List.insert_at(state, circular_pos + 1, count + 1)
    next_state(state, circular_pos + 1, count + 1)
  end
end

defmodule AOC.Day17b do
  @step_size 363
  @stop_at 50_000_000

  def solve do
    next_state([0], 0, 0)
  end

  def next_state(state, _, @stop_at) do
    Enum.at(state, Enum.find_index(state, & &1 == 0))
  end

  def next_state(state, pos, count) do
    if rem(count, 1_000) == 0 do
      IO.inspect Enum.at(state, Enum.find_index(state, & &1 == 0) + 1)
    end
    circular_pos = rem(pos + @step_size, length(state))
    state = List.insert_at(state, circular_pos + 1, count + 1)
    next_state(state, circular_pos + 1, count + 1)
  end
end
