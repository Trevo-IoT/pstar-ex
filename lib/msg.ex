defmodule PStar.Message do
  defstruct [:type, :star, :content]

  def encode(msg = %PStar.Message{}) do
    encode({msg.type, msg.star, msg.content})
  end

  def encode({type, star, content}) when is_atom(type) and is_binary(star) and is_binary(content) do
    cond do
      star |> String.length == 0 -> {:err, :star_empty}
      content |> String.length() == 0 -> {:err, :content_empty}
      true -> {raw, _} = PStar.Buffer.push(type |> encode_type |> :binary.encode_unsigned)
        |> PStar.Buffer.push(star |> String.length |> :binary.encode_unsigned)
        |> PStar.Buffer.push(content |> String.length |> :binary.encode_unsigned)
        |> PStar.Buffer.push(star)
        |> PStar.Buffer.push(content)
        {:ok, raw}
    end
  end

  def decode([type, star_len, content_len | raw]) when is_binary(raw) do
    cond do
      star_len + content_len > String.length(raw) -> {:err, :wrong_len}
      true ->
        {_, [content, star]} = raw
          |> PStar.Buffer.pop(star_len)
          |> PStar.Buffer.pop(content_len)

        {:ok, %PStar.Message{type: type |> decode_type, star: star, content: content}}
    end
  end

  defp decode_type(type) do
    case type do
      0x01 -> :connect
      0x02 -> :disconnect
      0x03 -> :data
      _ -> :unknown
    end
  end

  defp encode_type(type) do
    case type do
      :connect -> 0x01
      :disconnect -> 0x02
      :data -> 0x03
      _ -> 0xff
    end
  end
end
