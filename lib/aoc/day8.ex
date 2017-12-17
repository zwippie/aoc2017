defmodule AOC.Day8 do
  def solve do
    read_input()
    |> run_program(%{})
    |> Map.values
    |> Enum.max
  end

  def run_program([], registers), do: registers
  def run_program([{reg1, val1, reg2, op2, val2} | rest], registers) do
    reg2value = Map.get(registers, reg2, 0)

    registers = cond do
      apply(Kernel, op2, [reg2value, val2]) ->
        registers
        |> Map.put_new(reg1, 0)
        |> Map.update!(reg1, &(&1 + val1))
      true ->
        registers
    end

    run_program(rest, registers)
  end

  def read_input do
    File.read!("priv/input/day8.txt")
    |> String.split(~r{\n}, trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [reg1, op1, val1, reg2, op2, val2] =
      Regex.scan(~r/(\w+)\s(\w+)\s(-?\d+)\sif\s(\w+)\s(\!=|>|>=|<|<=|==)\s(-?\d+)/, line)
      |> List.flatten
      |> tl

    reg1 = String.to_atom(reg1)
    val1 = String.to_integer(val1)
    val1 = case op1 do
      "inc" -> val1
      "dec" -> -val1
    end
    reg2 = String.to_atom(reg2)
    op2 = String.to_atom(op2)
    val2 = String.to_integer(val2)

    {reg1, val1, reg2, op2, val2}
  end
end

defmodule AOC.Day8b do
  def solve do
    AOC.Day8.read_input()
    |> run_program(%{}, -999_999)
  end

  def run_program([], _registers, highest_value), do: highest_value
  def run_program([{reg1, val1, reg2, op2, val2} | rest], registers, highest_value) do
    reg2value = Map.get(registers, reg2, 0)

    registers = cond do
      apply(Kernel, op2, [reg2value, val2]) ->
        registers
        |> Map.put_new(reg1, 0)
        |> Map.update!(reg1, &(&1 + val1))
      true ->
        registers
    end

    hv_now =
      registers
      |> Map.values
      |> Enum.max
    highest_value = cond do
      hv_now > highest_value -> hv_now
      true -> highest_value
    end

    run_program(rest, registers, highest_value)
  end
end
