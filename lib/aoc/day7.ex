defmodule AOC.Day7 do
  @moduledoc """
  Find branch that is not in a child list
  """
  def solve do
    input = read_input()

    children =
      input
      |> Enum.filter(fn item -> elem(item, 0) == :branch end)
      |> Enum.flat_map(fn item -> elem(item, 3) end)

    input
    |> Enum.filter(fn item -> elem(item, 0) == :branch end)
    |> Enum.map(fn item -> elem(item, 1) end)
    |> Enum.reject(fn name -> name in children end)
    |> hd
  end

  def read_input do
    File.read!("priv/input/day7.txt")
    |> String.split(~r{\n}, trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    case Regex.scan(~r/\w+/, line) |> List.flatten do
      [name, weight] ->
        {:leaf, name, String.to_integer(weight), []}
      [name | [weight | leafs]] ->
        {:branch, name, String.to_integer(weight), leafs}
    end
  end
end


defmodule AOC.Day7b do
  # Result should be constructed from output, not that hard.
  def solve do
    programs = read_input()
    root_name = AOC.Day7.solve

    find_divergent_child(programs, root_name)
  end

  def find_divergent_child(programs, name) do
    child_weights(programs, name)
    |> divergent_value
    |> case do
      :equal -> programs[name]
      {:error, wrong_child, good_value} ->
        IO.inspect({wrong_child, good_value})
        find_divergent_child(programs, elem(wrong_child, 0))
    end
  end

  def child_weights(programs, name) do
    programs[name].children
    |> Enum.map(fn child_name ->
      {child_name, get_weight(programs, child_name)}
    end)
  end

  def divergent_value(weights) do
    grouped =
      weights
      |> Enum.group_by(& elem(&1, 1))
      |> Map.values

    cond do
      length(grouped) > 1 ->
        wrong_child = grouped |> Enum.min_by(&length/1) |> hd
        good_value = grouped |> Enum.max_by(&length/1) |> hd |> elem(1)
       {:error, wrong_child, good_value}
      true ->
        :equal
    end
  end

  def get_weight(programs, name) do
    programs[name].children
    |> Enum.reduce(0, fn node_name, acc ->
      node = programs[node_name]
      if node.type == :leaf do
        acc + node.weight
      else
        acc + get_weight(programs, node.name)
      end
    end)
    |> Kernel.+(programs[name].weight)
  end

  def read_input do
    File.read!("priv/input/day7.txt")
    |> String.split(~r{\n}, trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.into(%{})
  end

  def parse_line(line) do
    case Regex.scan(~r/\w+/, line) |> List.flatten do
      [name, weight] ->
        {name, %{name: name, type: :leaf, weight: String.to_integer(weight), children: []}}
      [name | [weight | children]] ->
        {name, %{name: name, type: :branch, weight: String.to_integer(weight), children: children}}
    end
  end
end
