defmodule KV.BucketTest do
  # The async option is used to run the tests in parallel
  # usin mulitple cores in the CPU
  # However, async should only be used if the test case
  # is not dependent by the global state of the application
  use ExUnit.Case, async: true

  # The setup block is used to setup the test environment
  # before running the tests
  # In this case, we are starting a new bucket for each test
  # When we return the map from the setup block, ExUnit will
  # merge this map with the test context so that we can access
  # the bucket in the tests
  setup do
    {:ok, bucket} = KV.Bucket.start_link([])
    %{bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end

  test "delete a value by key", %{bucket: bucket} do
    KV.Bucket.put(bucket, "tomato", 3)
    assert KV.Bucket.get(bucket, "tomato") == 3

    assert KV.Bucket.delete(bucket, "tomato") == 3
    assert KV.Bucket.get(bucket, "tomato") == nil
  end
end
