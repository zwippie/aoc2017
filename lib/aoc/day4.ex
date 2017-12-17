defmodule AOC.Day4 do
  @moduledoc """
  No double words in passphrases. How many are valid?
  """

  def solve do
    read_input()
    |> Enum.filter(&valid_passphrase/1)
    |> length
  end

  def valid_passphrase(words) do
    MapSet.new(words)
    |> MapSet.to_list
    |> length
    |> Kernel.==(length(words))
  end

  def read_input do
    File.read!("priv/input/day4.txt")
    |> String.split(~r{\n}, trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    String.split(line, ~r{\s}, trim: true)
  end
end

defmodule AOC.Day4b do
  @moduledoc """
  How many passphrases have no words that are anagrams?
  """

  def solve do
    AOC.Day4.read_input()
    |> Enum.filter(&valid_passphrase/1)
    |> length
  end

  def valid_passphrase(words) do
    words = Enum.with_index(words)

    (for {word1, idx1} <- words,
        {word2, idx2} <- words,
        idx1 < idx2,
        do: !anagrams?(word1, word2))
    |> Enum.find(true, & !&1)
  end

  def anagrams?(word1, word2) do
    (word1 |> String.split("", trim: true) |> Enum.sort) ==
    (word2 |> String.split("", trim: true) |> Enum.sort)
  end
end
