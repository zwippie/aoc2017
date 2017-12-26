defmodule AOC.Day24 do
  def solve do
    read_input()
    |> valid_bridges
    |> strongest_bridge
  end

  def strongest_bridge(bridges, acc \\ 0)
  def strongest_bridge([], acc), do: acc
  def strongest_bridge([head | tail], acc) do
    strength = Enum.reduce(head, 0, fn [a, b], acc -> acc + a + b end)
    cond do
      strength > acc -> strongest_bridge(tail, strength)
      true -> strongest_bridge(tail, acc)
    end
  end

  # Hmmm
  def valid_bridges(parts, last_port \\ 0, bridge \\ []) do
    case find_connectors(parts, last_port) do
      [] -> [bridge]
      connectors ->
        Enum.flat_map(connectors, fn part ->
          {parts, bridge} = connect_to(bridge, part, parts)
          valid_bridges(parts, new_port(part, last_port), bridge)
        end)
        |> Enum.concat([bridge])
    end
  end

  def connect_to(bridge, part, parts) do
    {part, parts} = List.pop_at(parts, Enum.find_index(parts, & &1 == part))
    {parts, [part | bridge]}
  end

  def find_connectors(parts, last_port, acc \\ [])
  def find_connectors([], _, acc), do: acc
  def find_connectors([head | tail], last_port, acc) do
    case connects?(head, last_port) do
      true ->
        find_connectors(tail, last_port, [head | acc])
      false ->
        find_connectors(tail, last_port, acc)
    end
  end

  def connects?([a, _b], port) when a == port, do: true
  def connects?([_a, b], port) when b == port, do: true
  def connects?(_, _), do: false

  def new_port([a, b], port) when a == port, do: b
  def new_port([a, b], port) when b == port, do: a
  def new_port([a, b], port), do: raise("Invalid connection [#{a}, #{b}] <-> #{port}")

  def read_input do
    Regex.scan(~r/(\d+)\/(\d+)/, File.read!("priv/input/day24.txt"), capture: :all_but_first)
    |> Enum.map(&parse_line/1)
  end

  def parse_line([a, b]) do
    [String.to_integer(a), String.to_integer(b)]
  end
end

defmodule AOC.Day24b do
  import AOC.Day24, except: [solve: 0]

  def solve do
    read_input()
    |> valid_bridges
    |> longest_bridges
    |> strongest_bridge
  end

  def longest_bridges(bridges) do
    bridges
    |> Enum.group_by(& length(&1))
    |> Map.values
    |> List.last
  end
end
