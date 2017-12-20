defmodule AOC.Day20 do
  @moduledoc """
  For each particle, it provides the X, Y, and Z coordinates for the particle's
  position (p), velocity (v), and acceleration (a), each in the format <X,Y,Z>
  Each tick, all particles are updated simultaneously. A particle's properties are updated in the following order:

  Increase the X velocity by the X acceleration.
  Increase the Y velocity by the Y acceleration.
  Increase the Z velocity by the Z acceleration.
  Increase the X position by the X velocity.
  Increase the Y position by the Y velocity.
  Increase the Z position by the Z velocity.
  """

  def solve do
    read_input()
    |> find_most_centered_particle(1_000)
  end

  def find_most_centered_particle(particles, 0) do
    particles
    |> Enum.with_index
    |> Enum.min_by(fn {{_p, _v, _a, d}, _idx} -> d end)
    |> elem(1)
  end

  def find_most_centered_particle(particles, count) do
    particles
    |> Enum.map(&next_state/1)
    |> find_most_centered_particle(count - 1)
  end

  def next_state({[px, py, pz], [vx, vy, vz], [ax, ay, az], _dist}) do
    {
      [px + (vx + ax), py + (vy + ay), pz + (vz + az)],
      [vx + ax, vy + ay, vz + az],
      [ax, ay, az],
      abs(px) + abs(py) + abs(pz)
    }
  end

  def read_input do
    File.read!("priv/input/day20.txt")
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&to_pva/1)
  end

  def to_pva(line) do
    [[p], [v], [a]] = Regex.scan(~r/(-?\d+,-?\d+,-?\d+)/, line, capture: :all_but_first)
    {
      String.split(p, ",", trim: true) |> Enum.map(&String.to_integer/1),
      String.split(v, ",", trim: true) |> Enum.map(&String.to_integer/1),
      String.split(a, ",", trim: true) |> Enum.map(&String.to_integer/1),
      0
    }
  end
end

defmodule AOC.Day20b do
  import AOC.Day20, only: [read_input: 0]

  def solve do
    read_input()
    |> find_free_particles(1_000)
  end

  def find_free_particles(particles, 0) do
    particles
    |> length
  end

  def find_free_particles(particles, count) do
    particles
    |> Enum.map(&next_state/1)
    |> remove_colliding_particles
    |> find_free_particles(count - 1)
  end

  def remove_colliding_particles(particles) do
    particles
    |> Enum.group_by(fn {x, _v, _a, _d} -> x end)
    |> Map.values
    |> Enum.filter(fn ps -> length(ps) == 1 end)
    |> List.flatten
  end

  def next_state({[px, py, pz], [vx, vy, vz], [ax, ay, az], _dist}) do
    {
      [px + (vx + ax), py + (vy + ay), pz + (vz + az)],
      [vx + ax, vy + ay, vz + az],
      [ax, ay, az],
      abs(px) + abs(py) + abs(pz)
    }
  end
end
