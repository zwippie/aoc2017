defmodule AOC.Day23b do
  @break_at 11000

  @init_memory (0..7)
    |> Enum.map(& {<<&1 + ?a>> |> String.to_atom, 0})
    |> Enum.into(%{ip: -1, state: :run, counter: 0})
    |> Map.put(:a, 1)

  def solve do
    read_input()
    |> run_program(@init_memory)
  end

  # def run_program(_, %{ip: 24} = memory), do: memory
  # def run_program(_, %{counter: @break_at} = memory), do: memory
  def run_program(_, %{state: :halt} = memory), do: memory # Map.get(memory, :h)
  def run_program(program, memory) do
    memory = Map.update!(memory, :ip, & &1 + 1)
    instruction = Enum.at(program, Map.get(memory, :ip))
    # if rem(Map.get(memory, :counter), 1_000_000) == 0 do
      # IO.inspect({memory, instruction}, width: 200)
    # end
    memory =
      perform_instruction(instruction, memory)
      |> Map.update!(:counter, & &1 + 1)
    run_program(program, memory)
  end

  # PERFORM INSTRUCTIONS

  def perform_instruction(nil, memory) do
    Map.put(memory, :state, :halt)
  end

  def perform_instruction({op, x, y}, memory) when is_atom(y) do
    perform_instruction(op, x, Map.get(memory, y), memory)
  end

  def perform_instruction({op, x, y}, memory) do
    perform_instruction(op, x, y, memory)
  end

  def perform_instruction(:set, x, y, memory) do
    Map.put(memory, x, y)
  end

  def perform_instruction(:sub, x, y, memory) do
    Map.update!(memory, x, & &1 - y)
  end

  def perform_instruction(:mul, x, y, memory) do
    Map.update!(memory, x, & &1 * y)
  end

  def perform_instruction(:jnz, x, y, memory) do
    if Map.get(memory, x) != 0 do
      Map.update!(memory, :ip, & &1 + y - 1)
    else
      memory
    end
  end

  # INPUT PARSING

  def read_input do
    File.read!("priv/input/day23b_A.txt")
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&to_command/1)
  end

  def to_command(cmd) do
    String.split(cmd, " ")
    |> case do
      [op, x]    -> to_command(op, x)
      [op, x, y] -> to_command(op, x, y)
    end
  end

  def to_command(op, x) do
    {String.to_atom(op), atom_or_integer(x)}
  end

  def to_command(op, x, y) do
    {String.to_atom(op), atom_or_integer(x), atom_or_integer(y)}
  end

  def atom_or_integer(val) do
    case Integer.parse(val) do
      :error -> String.to_atom(val)
      {num, _} -> num
    end
  end
end
