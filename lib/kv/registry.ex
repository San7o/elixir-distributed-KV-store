defmodule KV.Registry do
  use GenServer

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(opts) do
    # `__MODULE__` is the current module, where the
    # callbacks are implemented
    # :ok is the initialization argumet
    # `opts` is a list of options for the Server
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exixsts, `:error` otherwise.
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Ensuers there is a bucket associated with the given `name` in `server`.
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end


  ## Server callbacks
  #
  # We are using three callbackes:
  # - handle_call: synchronous calls
  # - handle_cast: asynchronous calls
  # - handle_info: messages that are not calls or casts

  @impl true
  # `@impl true` is a directive that tells the compiler
  # that the function is part of the GenServer behaviour
  # that should be implemented (an interface)
  def init(:ok) do
    names = %{} # will contain {name, pid}
    refs = %{} # will contain {ref, name}
    {:ok, {names, refs}}
  end

  # Calls are synchronous, the client is waiting for
  # a response
  @impl true
  def handle_call({:lookup, name}, _from, state) do
    {names, _} = state
    # format {:reply, reply, new_state}
    {:reply, Map.fetch(names, name), state}
  end

  # Casts are asynchronous, the server won't send a
  # response so the client won't wait for one
  @impl true
  def handle_cast({:create, name}, {names, refs}) do
    if Map.has_key?(names, name) do
      {:noreply, {names, refs}}
    else
      # Here we are both linking and monitoring the bucket
      # This is not a good idea, since we don't want the
      # registry to crash if the bucket crashes
      {:ok, bucket} = KV.Bucket.start_link([])
      ref = Process.monitor(bucket)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, bucket)
      {:noreply, {names, refs}}
    end
  end

  @impl true
  # Must be used for all messages a server may receive
  # that are not sent via `call` or `cast`, including
  # regular messages set with `send`
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs} ) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end

  @impl true
  # This function discards and logs any unknown message.
  # It's a "catch-all" function, if we don't define this
  # those messages could cause our registry do crash
  # because no clause would match
  def handle_info(msg, state) do
    require Logger
    Logger.debug("Unexpected message in KV.Registry: #{inspect(msg)}")
    {:noreply, state}
  end
end
