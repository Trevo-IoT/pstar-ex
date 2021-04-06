defmodule PStar.BufferTest do
  use ExUnit.Case
  doctest PStar.Buffer

  test "push data" do
    {b, _} = PStar.Buffer.new |> PStar.Buffer.push("Hello") |> PStar.Buffer.push(" world")

    assert b == "Hello world"
  end

  test "pop data" do
    ["Hello", " world"]
    {_, [v2, v1]} = {"Hello world", []} |> PStar.Buffer.pop(5) |> PStar.Buffer.pop(6)

    assert v1 == "Hello"
    assert v2 == " world"
  end
end
