defmodule PStar do
  require Logger
  @moduledoc """
  Documentation for `PStar`.
  """

  @port 0x5053

  @doc """
  Open port 0x5053 to receive protocol requisitions.

  Returns: `:ok`.

  ## Examples

      iex> PStar.start
      :ok

  """
  @doc since: "0.1.0"
  def start do
    {:ok, socket} = :gen_tcp.listen(@port, [:binary, :inet, active: false, header: 3, keepalive: true, packet: :raw])
    Logger.info("Accepting connections on port #{@port}")
    accept_loop(socket)
  end

  @doc """
  Creates new star with name `star`.

  Returns: `{:ok, PID} or {:err, reason}`

  ## Examples

      iex> PStar.open("hello")
      {:ok, PID}
      iex> PStar.open("hello")
      {:err, :exist}
  """
  def open(star) do
    # add star to constellation

    # new center task
  end

  def close(star) do
    #check if is in constellation

    # kill center task
    # kill edge task associated with star
    # remove from constelation
  end

  def broadcast(star, content) do
    # check
  end

  defp accept_loop(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    Logger.info("New connection accepted")
    Task.start_link(fn -> handle_incoming(client) end)
    accept_loop(socket)
  end



  def handle_incoming(socket) do
    {:ok, raw_data} = socket |> :gen_tcp.recv(0)

    {:ok, decoded_data} = raw_data |> PStar.Message.decode

    :ok = decoded_data |> handle

    handle_incoming(socket)
  end

  defp handle(%PStar.Message{type: :connect, star: _star}) do
    :ok
  end

  defp handle(%PStar.Message{type: :disconnect, star: _star}) do
    :ok
  end

  defp handle(%PStar.Message{type: :data, star: _star, content: _content}) do
    :ok
  end
end
