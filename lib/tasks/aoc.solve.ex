defmodule Mix.Tasks.Aoc.Solve do
  use Mix.Task

  @shortdoc "Solve the problem of day <argument> and show the result"

  def run(day) do
    Module.safe_concat([AOC, "Day#{day}"])
    |> apply(:solve, [])
    |> IO.inspect
  end
end
