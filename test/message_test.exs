defmodule PStar.MessageTest do
  use ExUnit.Case, async: true
  doctest PStar.Message

  test "encode right msg with struct" do
    {:ok, raw} = %PStar.Message{
      type: :connect,
      star: "test",
      content: "Hello World"
    } |> PStar.Message.encode
    assert raw == "\x01\x04\x0btestHello World"
  end

  test "encode right msg with tuple" do
    {:ok, raw} = {:disconnect, "test", "Hello World"} |> PStar.Message.encode
    assert raw == "\x02\x04\x0btestHello World"
  end

  test "encode without star" do
    {:err, reason} = {:data, "", "Hello World"} |> PStar.Message.encode

    assert reason == :star_empty
  end

  test "encode without content" do
    {:err, reason} = {:data, "test", ""} |> PStar.Message.encode

    assert reason == :content_empty
  end

  test "decode right msg" do
    raw = "testHello World"
    {:ok, %PStar.Message{
      type: type,
      star: star,
      content: content
    }} = PStar.Message.decode([0x01, 4, 11 | raw])

    assert type == :connect
    assert star == "test"
    assert content == "Hello World"
  end

  test "decode small message" do
    {:err, reason} = PStar.Message.decode([0x02, 1, 1 | ""])

    assert reason == :wrong_len
  end

  test "decode wrong len" do
    raw = "ab"
    {:err, reason} = PStar.Message.decode([0x03, 2, 1 | raw])

    assert reason == :wrong_len
  end
end
