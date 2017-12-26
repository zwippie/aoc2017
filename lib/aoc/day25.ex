defmodule AOC.Day25 do
  @start_regex ~r/Begin in state (\w).\nPerform a diagnostic checksum after (\d+) steps./

  @blueprint_regex ~r/In state (\w):
  If the current value is 0:
    - Write the value (\d).
    - Move one slot to the (left|right).
    - Continue with state (\w).
  If the current value is 1:
    - Write the value (\d).
    - Move one slot to the (left|right).
    - Continue with state (\w)./

  @append_size 10

  def solve do
    {initial_state, max_count, rules} = read_input()

    next_state([0], 0, rules, initial_state, max_count)
    |> Enum.filter(& &1 == 1)
    |> length
  end

  def next_state(memory, _, _, _, 0), do: memory

  def next_state(memory, mem_idx, rules, state, counter) do
    rule = Map.fetch!(rules, state) |> Map.fetch!(Enum.at(memory, mem_idx))
    if rem(counter, 100_000) == 0, do: IO.inspect({counter, length(memory), mem_idx, state, rule})
    {memory, mem_idx} = apply_rule(memory, mem_idx, rule)
    next_state(memory, mem_idx, rules, rule.next, counter - 1)
  end

  def apply_rule(memory, mem_idx, rule) do
    memory = List.replace_at(memory, mem_idx, rule.to)
    move_idx(memory, mem_idx, rule.dir)
  end

  def move_idx(memory, mem_idx, :left) when mem_idx == 0 do
    {List.duplicate(0, @append_size) ++ memory, @append_size - 1}
  end

  def move_idx(memory, mem_idx, :left) do
    {memory, mem_idx - 1}
  end

  def move_idx(memory, mem_idx, :right) when mem_idx + 1 == length(memory) do
    {memory ++ List.duplicate(0, @append_size), mem_idx + 1}
  end

  def move_idx(memory, mem_idx, :right) do
    {memory, mem_idx + 1}
  end

  def read_input do
    input = File.read!("priv/input/day25.txt")
    [[initial_state, max_count]] = Regex.scan(@start_regex, input, capture: :all_but_first)
    rules =
      Regex.scan(@blueprint_regex, input, capture: :all_but_first)
      |> Enum.map(&parse_rule/1)
      |> Map.new
    {initial_state, String.to_integer(max_count), rules}
  end

  def parse_rule([state, to_0, dir_0, next_0, to_1, dir_1, next_1]) do
    {state,
      %{
        0 => %{to: String.to_integer(to_0), dir: String.to_atom(dir_0), next: next_0},
        1 => %{to: String.to_integer(to_1), dir: String.to_atom(dir_1), next: next_1}
      }
    }
  end

end
