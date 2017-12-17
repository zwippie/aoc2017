defmodule AOC.Day15 do
  use Bitwise, only_operators: true

  @gen_a_start 634
  @gen_b_start 301

  @gen_a_factor 16807
  @gen_b_factor 48271

  @divider 2147483647
  @compare_count 40_000_000

  @mask (1 <<< 16) - 1

  def solve do
    [@gen_a_start, @gen_b_start]
    |> find_equal_lower_bits(0, 0)
  end

  def find_equal_lower_bits(_, @compare_count, equal_count), do: equal_count
  def find_equal_lower_bits(pair, count, equal_count) do
    equal_count = cond do
      lower_bits_equal(pair) -> equal_count + 1
      true -> equal_count
    end
    pair
    |> next_pair
    |> find_equal_lower_bits(count + 1, equal_count)
  end

  def lower_bits_equal([val_a, val_b]) do
    (val_a &&& @mask) == (val_b &&& @mask)
  end

  def next_pair([val_a, val_b]) do
    [rem(val_a * @gen_a_factor, @divider),
     rem(val_b * @gen_b_factor, @divider)]
  end
end

defmodule AOC.Day15b do
  use Bitwise, only_operators: true

  @gen_a_start 634
  @gen_b_start 301

  @gen_a_factor 16807
  @gen_b_factor 48271

  @divider 2147483647
  @compare_count 5_000_000

  @mask (1 <<< 16) - 1

  def solve do
    [@gen_a_start, @gen_b_start]
    |> find_equal_lower_bits(0, 0)
  end

  def find_equal_lower_bits(_, @compare_count, equal_count), do: equal_count
  def find_equal_lower_bits(pair, count, equal_count) do
    equal_count = cond do
      lower_bits_equal(pair) -> equal_count + 1
      true -> equal_count
    end
    pair
    |> next_pair
    |> find_equal_lower_bits(count + 1, equal_count)
  end

  def lower_bits_equal([val_a, val_b]) do
    (val_a &&& @mask) == (val_b &&& @mask)
  end

  def next_pair([val_a, val_b]) do
    [next_a(val_a), next_b(val_b)]
  end

  def next_a(val_a) do
    val_a = rem(val_a * @gen_a_factor, @divider)
    cond do
      (val_a &&& 3) == 0 -> val_a
      true -> next_a(val_a)
    end
  end

  def next_b(val_b) do
    val_b = rem(val_b * @gen_b_factor, @divider)
    cond do
      (val_b &&& 7) == 0 -> val_b
      true -> next_b(val_b)
    end
  end
end
