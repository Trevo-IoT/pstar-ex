defmodule PStarTest do
  use ExUnit.Case
  doctest PStar

  test "greets the world" do
    assert PStar.hello() == :world
  end
end
