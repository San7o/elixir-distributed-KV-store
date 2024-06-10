defmodule KV.BucketTest do
  # The async option is used to run the tests in parallel
  # usin mulitple cores in the CPU
  # However, async should only be used if the test case
  # is not dependent by the global state of the application
  use ExUnit.Case, async: true

  test "stores values by key" do
    {:ok, bucket} = KV.Bucket.start_link([])
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end
end
