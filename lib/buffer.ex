defmodule PStar.Buffer do
  def new do
    {"", []}
  end

  def push(v) when is_binary(v) do
    {v, []}
  end

  def push({b, l}, v) when is_binary(b) and is_binary(v) and is_list(l) do
    {b <> v, l}
  end

  def pop({b, l}, n) when is_binary(b) and is_integer(n) and is_list(l) do
    cond do
      n > String.length(b) or n < 0 -> {b, l}
      true -> {b |> String.slice(n..-1), [b |> String.slice(0..n-1) | l]}
    end
  end

  def pop(b, n) when is_binary(b) and is_integer(n) do
    cond do
      n > String.length(b) or n < 0 -> {b, []}
      true -> {b |> String.slice(n..-1), [b |> String.slice(0..n-1)]}
    end
  end
end
