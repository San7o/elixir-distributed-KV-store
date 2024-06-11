defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  # Start the GenServer and return the registry
  setup do
    # Start supervised calls the start_link function,
    # start_supervised! will garantee that the GenServer
    # will be shutdown before the next test starts: the
    # state of one server won't affect the state of the
    # next one
    registry = start_supervised!(KV.Registry)
    %{registry: registry}
  end

  test "Add an item to the registry through backend api", %{registry: registry} do
    GenServer.cast(registry, {:create, "shopping"})
    {:ok, bk} = GenServer.call(registry, {:lookup, "shopping"})
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

    Agent.stop(bucket)
    assert KV.Registry.lookup(registry, "shopping") == :error
  end

end
