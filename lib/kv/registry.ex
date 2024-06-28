defmodule KV.Registry do
  use GenServer

  ## Client API

  @doc """
  Starts the registry with the given options.

  `:name` is always required.
  """
  def start_link(opts) do
    server = Keyword.fetch!(opts, :name)
    # `__MODULE__` is the current module, where the
    # callbacks are implemented
    # :ok is the initialization argumet
    # `opts` is a list of options for the Server
    GenServer.start_link(__MODULE__, server, opts)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exixsts, `:error` otherwise.
  """
  def lookup(server, name) do
    case :ets.lookup(server, name) do
      [{^name, pid}] -> {:ok, pid}
      [] -> :error
    end
  end

  @doc """
  Ensuers there is a bucket associated with the given `name` in `server`.
  """
  def create(server, name) do
    GenServer.call(server, {:create, name})
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
  def init(table) do
    # By default, the table will use:
    # :protected - only the process that created the table can write to it
    #              but any process can read from it
    # :set - the table will not allow duplicate keys
    #
    # We are using:
    # :read_concurrency - allows multiple processes to read from the table
    names = :ets.new(table, [:named_table, read_concurrency: true])
    # will contain {ref, name}
    refs = %{}
    {:ok, {names, refs}}
  end

  @doc """
  OLD: Example handle_call

  # Calls are synchronous, the client is waiting for
  # a response
  @impl true
  def handle_call({:lookup, name}, _from, state) do
    {names, _} = state
    # format {:reply, reply, new_state}
    {:reply, Map.fetch(names, name), state}
  end
  """

  @impl true
  def handle_call({:create, name}, _from, {names, refs}) do
    case lookup(names, name) do
      {:ok, pid} ->
        {:reply, pid, {names, refs}}

      :error ->
        {:ok, pid} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
        ref = Process.monitor(pid)
        refs = Map.put(refs, ref, name)
        :ets.insert(names, {name, pid})
        {:reply, pid, {names, refs}}
    end
  end

  @impl true
  # Must be used for all messages a server may receive
  # that are not sent via `call` or `cast`, including
  # regular messages set with `send`
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    :ets.delete(names, name)
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
