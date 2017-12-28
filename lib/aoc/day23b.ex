defmodule AOC.Day23b do
  @b 108400
  @c 125400

  def solve do
    (@b..@c)
    |> Stream.take_every(17)
    |> Enum.count(& !is_prime(&1))
  end

  def is_prime(x) do
    IO.inspect(x)
    (2..x |> Enum.filter(fn a -> rem(x, a) == 0 end) |> length()) == 1
  end
end
