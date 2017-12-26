defmodule AOC.Day23 do
  @moduledoc """
  - set X Y sets register X to the value of Y.
  - sub X Y decreases register X by the value of Y.
  - mul X Y sets register X to the result of multiplying the value contained in register X by the value of Y.
  - jnz X Y jumps with an offset of the value of Y, but only if the value of X is not zero.
    (An offset of 2 skips the next instruction, an offset of -1 jumps to the previous instruction, and so on.)

  Only the instructions listed above are used. The eight registers here, named a through h, all start at 0.

  If you run the program (your puzzle input), how many times is the mul instruction invoked?
  """

  # a..p for registers, :freq for last freq, :rcv for last recovered freq when, :ip for instruction pointer
  @init_memory (0..7)
    |> Enum.map(& {<<&1 + ?a>> |> String.to_atom, 0})
    |> Enum.into(%{ip: -1, state: :run, mul_invoked: 0})

  def solve do
    read_input()
    |> run_program(@init_memory)
  end

  def run_program(_, %{state: :halt} = memory), do: Map.get(memory, :mul_invoked)
  def run_program(program, memory) do
    memory = Map.update!(memory, :ip, & &1 + 1)
    instruction = Enum.at(program, Map.get(memory, :ip))
    run_program(program, perform_instruction(instruction, memory))
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
    memory
    |> Map.update!(x, & &1 * y)
    |> Map.update!(:mul_invoked, & &1 + 1)
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
    File.read!("priv/input/day23.txt")
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
