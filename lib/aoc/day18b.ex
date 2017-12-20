defmodule AOC.Day18b do
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

  snd X sends the value of X to the other program. These values wait in a queue until that program is
    ready to receive them. Each program has its own message queue, so a program can never receive a message it sent.
  rcv X receives the next value and stores it in register X. If no values are in the queue, the program waits
    for a value to be sent to it. Programs do not continue to the next instruction until they have received a value.
    Values are received in the order they are sent.
  """

  # a..p for registers, :ip for instruction pointer, state: run, halt (done)
  @init_memory (0..15)
    |> Enum.map(& {<<&1 + ?a>> |> String.to_atom, 0})
    |> Enum.into(%{ip: -1, state: :run, send_count: 0, other_pid: nil, original_p: 0})

  def solve do
    program = read_input()

    pid_a = spawn_link(__MODULE__, :start, [program, @init_memory])
    pid_b = spawn_link(__MODULE__, :start, [program, %{@init_memory | p: 1, original_p: 1}])

    send pid_a, pid_b
    send pid_b, pid_a

    # Wait for program b to finish
    ref_b = Process.monitor(pid_b)
    receive do
      {:DOWN, ^ref_b, _, _, _} -> :ok
    end
  end

  def start(program, memory) do
    memory = receive do
      other_pid -> %{memory | other_pid: other_pid}
    end
    run_program(program, memory)
  end

  def run_program(_, %{state: :halt} = memory) do
    IO.puts "Program #{Map.get(memory, :original_p)} is done, send count: #{Map.get(memory, :send_count)}"
  end

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
    send(Map.get(memory, :other_pid), Map.get(memory, x))
    Map.update!(memory, :send_count, & &1 + 1)
  end

  def perform_instruction(:rcv, x, memory) do
    receive do
      val ->
        Map.put(memory, x, val)
    after
      5000 -> Map.put(memory, :state, :halt)
    end
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
