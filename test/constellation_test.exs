defmodule PStar.ConstellationTest do
  use ExUnit.Case, async: true
  doctest PStar.Constellation

  @star_name "hello"

  setup do
    constallation = start_supervised!(PStar.Constellation)
    %{constallation: constallation}
  end

  test "new star", %{constallation: constallation} do
    center = :c.pid(0, 50, 0)
    :ok = constallation |> PStar.Constellation.new(@star_name, center)
  end

  test "del star", %{constallation: constallation} do
    center = :c.pid(0, 50, 0)
    :ok = constallation |> PStar.Constellation.new(@star_name, center)
    :ok = constallation |> PStar.Constellation.del(@star_name)
  end

  test "get center", %{constallation: constallation} do
    exp_center = :c.pid(0, 50, 0)
    :ok = constallation |> PStar.Constellation.new(@star_name, exp_center)
    {:ok, center} = constallation |> PStar.Constellation.center(@star_name)
    assert exp_center == center
  end

  test "new edge", %{constallation: constallation} do
    center = :c.pid(0, 50, 0)
    edge = :c.pid(0, 51, 0)
    :ok = constallation |> PStar.Constellation.new(@star_name, center)
    :ok = constallation |> PStar.Constellation.new_edge(@star_name, edge)
  end

  test "del edge", %{constallation: constallation} do
    center = :c.pid(0, 50, 0)
    edge = :c.pid(0, 51, 0)
    :ok = constallation |> PStar.Constellation.new(@star_name, center)
    :ok = constallation |> PStar.Constellation.new_edge(@star_name, edge)
    :ok = constallation |> PStar.Constellation.del_edge(@star_name, edge)
  end

  test "get edges", %{constallation: constallation} do
    center = :c.pid(0, 50, 0)
    exp_edges = [:c.pid(0, 51, 0), :c.pid(0, 52, 0), :c.pid(0, 53, 0)]
    :ok = constallation |> PStar.Constellation.new(@star_name, center)
    exp_edges |> Enum.each(fn e -> PStar.Constellation.new_edge(constallation, @star_name, e) end)

    {:ok, edges} = constallation |> PStar.Constellation.edges(@star_name)

    assert exp_edges == edges |> Enum.reverse
  end
end
