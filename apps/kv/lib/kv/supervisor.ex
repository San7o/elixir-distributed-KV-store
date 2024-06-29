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
      # A dynamic supervisor is a supervisor that
      # can start children dynamically. Since it does not
      # define any children during initialization, we can
      # skip having a separate module for it
      {DynamicSupervisor, name: KV.BucketSupervisor, strategy: :one_for_one},
      # The supervisor will call
      # `KV.Registry.start_link(name: KV.Registry)`
      # This way, we are starting named buckets
      # and we can refer to them by name
      {KV.Registry, name: KV.Registry},

      # Creating a task supervisor for distributed tasks
      {Task.Supervisor, name: KV.RouterTasks}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
