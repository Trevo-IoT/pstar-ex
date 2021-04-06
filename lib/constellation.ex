defmodule PStar.Constellation do
  use GenServer

  ## Client API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def new(server, star, center) do
    server |> GenServer.call({:new, star, center})
  end

  def del(server, star) do
    server |> GenServer.call({:del, star})
  end

  def center(server, star) do
    server |> GenServer.call({:center, star})
  end

  def edges(server, star) do
    server |> GenServer.call({:edges, star})
  end

  def new_edge(server, star, edge) do
    server |> GenServer.call({:new_edge, star, edge})
  end

  def del_edge(server, star, edge) do
    server |> GenServer.call({:del_edge, star, edge})
  end

  ## Server Callbacks
  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:new, star, center}, _from, state) when is_binary(star) and is_pid(center) do
    case Map.fetch(state, star) do
      {:ok, _} -> {:reply, :error, state}
      _ ->
        state = Map.put_new(state, star, {center, []})
        {:reply, :ok, state}
    end
  end

  @impl true
  def handle_call({:del, star}, _from, state) when is_binary(star) do
    case Map.fetch(state, star) do
      {:ok, _} ->
        state = Map.delete(state, star)
        {:reply, :ok, state}
      _ -> {:reply, :error, state}
    end
  end

  @impl true
  def handle_call({:center, star}, _from, state) when is_binary(star) do
    case Map.fetch(state, star) do
      {:ok, {center, _}} -> {:reply, {:ok, center}, state}
      _ -> {:reply, :error, state}
    end
  end

  @impl true
  def handle_call({:edges, star}, _from, state) when is_binary(star) do
    case Map.fetch(state, star) do
      {:ok, {_, edges}} -> {:reply, {:ok, edges}, state}
      _ -> {:reply, :error, state}
    end
  end

  @impl true
  def handle_call({:new_edge, star, edge}, _from, state) when is_binary(star) and is_pid(edge) do
    case Map.fetch(state, star) do
      {:ok, {center, edges}} ->
        case Enum.find(edges, &(&1 == edge)) do
          nil -> edges = [edge | edges]
            state = Map.put(state, star, {center, edges})
            {:reply, :ok, state}
          _ -> {:reply, :error, state}
        end
      _ -> {:reply, :error, state}
    end
  end

  @impl true
  def handle_call({:del_edge, star, edge}, _from, state) when is_binary(star) and is_pid(edge) do
    case Map.fetch(state, star) do
      {:ok, {center, edges}} ->
        case Enum.find(edges, &(&1 == edge)) do
          nil -> {:reply, :error, state}
          _ -> edges = Enum.reject(edges, &(&1 == edge))
            state = Map.put(state, star, {center, edges})
            {:reply, :ok, state}
        end
      _ -> {:reply, :error, state}
    end
  end
end
