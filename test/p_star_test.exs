defmodule PStarTest do
  use ExUnit.Case
  doctest PStar

  @addr {127, 0, 0, 1}
  @port 0x5053

  test "client echo" do
    data_out = "\x01\x04\x0btestHello World"

    Task.start_link(fn -> PStar.start end)

    {:ok, client} = :gen_tcp.connect(@addr, @port, [:binary, :inet, active: false, keepalive: true, packet: :raw])
    client |> :gen_tcp.send(data_out)
    {:ok, data_in} = client |> :gen_tcp.recv(0)
    client |> :gen_tcp.close

    assert data_in == data_out
  end
end
