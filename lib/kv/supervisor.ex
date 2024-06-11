defmodule KV.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  # Init will traverse the list of children and it
  # will invoke the `child_spec` function for each
  # `child_spec` is automatically defined when using
  # `use Agent`, `use GenServer`, `use Supervisor`
  def init(:ok) do
    children = [
      # The supervisor will call
      # `KV.Registry.start_link(name: KV.Registry)`
      # This way, we are starting named buckets
      # and we can refer to them by name
      {KV.Registry, name: KV.Registry}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
