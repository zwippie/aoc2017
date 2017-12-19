defmodule AOC.Day18 do
  @moduledoc """
  snd X plays a sound with a frequency equal to the value of X.
  set X Y sets register X to the value of Y.
  add X Y increases register X by the value of Y.
  mul X Y sets register X to the result of multiplying the value contained in register X by the value of Y.
  mod X Y sets register X to the remainder of dividing the value contained in register X by the value of Y
    (that is, it sets X to the result of X modulo Y).
  rcv X recovers the frequency of the last sound played, but only when the value of X is not zero.
    (If it is zero, the command does nothing.)
  jgz X Y jumps with an offset of the value of Y, but only if the value of X is greater than zero.
    (An offset of 2 skips the next instruction, an offset of -1 jumps to the previous instruction, and so on.)
  """

  # a..p for registers, :freq for last freq, :rcv for last recovered freq when, :ip for instruction pointer
  @init_memory (0..15)
    |> Enum.map(& {<<&1 + ?a>> |> String.to_atom, 0})
    |> Enum.into(%{freq: nil, rcv: nil, ip: -1, state: :run})

  def solve do
    read_input()
    |> run_program(@init_memory)
  end

  def run_program(_, %{state: :halt} = memory), do: Map.get(memory, :rcv)
  def run_program(program, memory) do
    memory = Map.update!(memory, :ip, & &1 + 1)
    instruction = Enum.at(program, Map.get(memory, :ip))
    run_program(program, perform_instruction(instruction, memory))
  end


  # PERFORM INSTRUCTIONS

  def perform_instruction({op, x}, memory) do
    perform_instruction(op, x, memory)
  end

  def perform_instruction({op, x, y}, memory) when is_atom(y) do
    perform_instruction(op, x, Map.get(memory, y), memory)
  end

  def perform_instruction({op, x, y}, memory) do
    perform_instruction(op, x, y, memory)
  end

  def perform_instruction(:snd, x, memory) do
    Map.put(memory, :freq, x)
  end

  def perform_instruction(:set, x, y, memory) do
    Map.put(memory, x, y)
  end

  def perform_instruction(:add, x, y, memory) do
    Map.update!(memory, x, & &1 + y)
  end

  def perform_instruction(:mul, x, y, memory) do
    Map.update!(memory, x, & &1 * y)
  end

  def perform_instruction(:mod, x, y, memory) do
    Map.update!(memory, x, & rem(&1, y))
  end

  def perform_instruction(:rcv, x, memory) do
    if x > 0 do
      memory
      |> Map.put(:rcv, Map.get(memory, :freq))
      |> Map.put(:state, :halt)
    else
      memory
    end
  end

  def perform_instruction(:jgz, x, y, memory) do
    if Map.get(memory, x) > 0 do
      Map.update!(memory, :ip, & &1 + y - 1)
    else
      memory
    end
  end


  # INPUT PARSING

  def read_input do
    File.read!("priv/input/day18.txt")
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
