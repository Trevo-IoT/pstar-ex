defmodule PStar.ConstellationTest do
  use ExUnit.Case, async: true
  doctest PStar.Constellation

  @star_name "hello"

  setup do
    constellation = start_supervised!(PStar.Constellation)
    %{constellation: constellation}
  end

  test "new star", %{constellation: constellation} do
    center = :c.pid(0, 50, 0)

    assert :ok = constellation |> PStar.Constellation.new(@star_name, center)
  end

  test "double star", %{constellation: constellation} do
    center = :c.pid(0, 50, 0)

    :ok = constellation |> PStar.Constellation.new(@star_name, center)
    assert :error = constellation |> PStar.Constellation.new(@star_name, center)
  end

  test "del star", %{constellation: constellation} do
    center = :c.pid(0, 50, 0)

    :ok = constellation |> PStar.Constellation.new(@star_name, center)
    assert :ok = constellation |> PStar.Constellation.del(@star_name)
  end

  test "del non-existent star", %{constellation: constellation} do
    assert :error = constellation |> PStar.Constellation.del(@star_name)
  end

  test "get center", %{constellation: constellation} do
    exp_center = :c.pid(0, 50, 0)
    :ok = constellation |> PStar.Constellation.new(@star_name, exp_center)
    {:ok, center} = constellation |> PStar.Constellation.center(@star_name)

    assert exp_center == center
  end

  test "new edge", %{constellation: constellation} do
    center = :c.pid(0, 50, 0)
    edge = :c.pid(0, 51, 0)
    :ok = constellation |> PStar.Constellation.new(@star_name, center)

    assert :ok = constellation |> PStar.Constellation.new_edge(@star_name, edge)
  end

  test "del edge", %{constellation: constellation} do
    center = :c.pid(0, 50, 0)
    edge = :c.pid(0, 51, 0)
    :ok = constellation |> PStar.Constellation.new(@star_name, center)
    :ok = constellation |> PStar.Constellation.new_edge(@star_name, edge)

    assert :ok = constellation |> PStar.Constellation.del_edge(@star_name, edge)
  end

  test "del non-existent edge", %{constellation: constellation} do
    center = :c.pid(0, 50, 0)
    edge = :c.pid(0, 51, 0)
    other_edge = :c.pid(0, 52, 0)
    :ok = constellation |> PStar.Constellation.new(@star_name, center)
    :ok = constellation |> PStar.Constellation.new_edge(@star_name, edge)

    assert :error = constellation |> PStar.Constellation.del_edge(@star_name, other_edge)
  end

  test "get edges", %{constellation: constellation} do
    center = :c.pid(0, 50, 0)
    exp_edges = [:c.pid(0, 51, 0), :c.pid(0, 52, 0), :c.pid(0, 53, 0)]
    :ok = constellation |> PStar.Constellation.new(@star_name, center)
    exp_edges |> Enum.each(fn e -> PStar.Constellation.new_edge(constellation, @star_name, e) end)

    assert {:ok, edges} = constellation |> PStar.Constellation.edges(@star_name)
    assert exp_edges == edges |> Enum.reverse
  end

  test "get infos without new", %{constellation: constellation} do
    assert :error = constellation |> PStar.Constellation.center(@star_name)
    assert :error = constellation |> PStar.Constellation.edges(@star_name)
  end

  test "set infos without new", %{constellation: constellation} do
    edge = :c.pid(0, 51, 0)

    assert :error = constellation |> PStar.Constellation.new_edge(@star_name, edge)
    assert :error = constellation |> PStar.Constellation.del_edge(@star_name, edge)
  end
end
