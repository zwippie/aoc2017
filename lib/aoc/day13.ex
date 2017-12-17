defmodule AOC.Day13 do
  def solve do
    read_input()
    |> initial_state
    |> move_to_next_layer(0, 0)
  end

  def move_to_next_layer(state, idx, score) when idx >= length(state), do: score
  def move_to_next_layer(state, idx, score) do
    layer = Enum.at(state, idx)
    score = cond do
      layer.at == 0 -> score + (idx * layer.depth)
      true -> score
    end
    move_to_next_layer(next_state(state), idx + 1, score)
  end

  def next_state(state) do
    state
    |> Enum.map(&update_layer/1)
  end

  def update_layer(%{depth: 0} = layer), do: layer
  def update_layer(%{depth: depth, at: at, dir: dir}) do
    cond do
      dir == :down && at == depth - 1 ->
        %{depth: depth, at: at - 1, dir: :up}
      dir == :down ->
        %{depth: depth, at: at + 1, dir: :down}
      dir == :up && at == 0 ->
        %{depth: depth, at: at + 1, dir: :down}
      dir == :up ->
        %{depth: depth, at: at - 1, dir: :up}
    end
  end

  def initial_state(input) do
    last_layer = Map.keys(input) |> Enum.max
    0..last_layer
    |> Enum.map(fn idx ->
      %{
        depth: Map.get(input, idx, 0),
        at: 0,
        dir: :down
      }
    end)
  end

  def read_input do
    File.read!("priv/input/day13.txt")
    |> String.split(~r{\n}, trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.into(%{})
  end

  def parse_line(line) do
    line
    |> String.split(": ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple
  end
end

defmodule AOC.Day13b do
  import AOC.Day13, except: [solve: 0, move_to_next_layer: 3]

  def solve do
    read_input()
    |> initial_state
    |> find_delay(0)
  end

  def find_delay(state, delay) do
    cond do
      is_safe_passage(state, 0) -> delay
      true -> find_delay(next_state(state), delay + 1)
    end
  end

  def is_safe_passage(state, idx) when idx >= length(state), do: true
  def is_safe_passage(state, idx) do
    layer = Enum.at(state, idx)
    cond do
      layer.depth > 0 && layer.at == 0 -> false
      true -> is_safe_passage(next_state(state), idx + 1)
    end
  end
end
