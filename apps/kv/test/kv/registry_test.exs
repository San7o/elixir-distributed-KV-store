defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  # Start the GenServer and return the registry
  setup context do
    # Start supervised calls the start_link function,
    # start_supervised! will garantee that the GenServer
    # will be shutdown before the next test starts: the
    # state of one server won't affect the state of the
    # next one
    # Since each test has a unique name, we use the test
    # name to name our registries
    _ = start_supervised!({KV.Registry, name: context.test})
    %{registry: context.test}
  end

  test "Add an item to the registry through backend api", %{registry: registry} do
    GenServer.call(registry, {:create, "shopping"})
    {:ok, bk} = KV.Registry.lookup(registry, "shopping")
    assert is_pid(bk)
  end

  test "spawn buckets through frontend API", %{registry: registry} do
    assert KV.Registry.lookup(registry, "shopping") == :error

    KV.Registry.create(registry, "shopping")
    assert {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    # default reason is :normal
    Agent.stop(bucket)
    # Do a call to ensure the registry processed the DOWN message
    # We need this because Agent.stop is sunchronous but handle_info
    # is asynchronous, so we need to let handle_info(:DOWN) run to
    # remove the bucket from the registry
    _ = KV.Registry.create(registry, "bogus")
    assert KV.Registry.lookup(registry, "shopping") == :error
  end

  # We want the registry to be alive even when the bucket crashes
  test "removes bucket on crash", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    # Stop the bucket with non-normal reason
    Agent.stop(bucket, :shutdown)
    # Do a call to ensure the registry processed the DOWN message
    _ = KV.Registry.create(registry, "bogus")
    assert KV.Registry.lookup(registry, "shopping") == :error
  end

  test "are temporary workers" do
    assert Supervisor.child_spec(KV.Bucket, []).restart == :temporary
  end
end
