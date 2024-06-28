defmodule KV.Bucket do
  # `restart: :temporary` means that the Agent will not be
  # restarted if it crashes. We want this because when the 
  # supervisor restarts the new bucket, the registry does
  # not know about it.
  use Agent, restart: :temporary

  @doc """
  Starts a new bucket.
  """
  @spec start_link([any]) :: {:ok, pid} | {:error, term}
  # It's a convention to take _opts as an argument, as
  # we might need to pass some options in the future
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Gets a value from the `bucket` by `key`.
  """
  def get(bucket, key) do
    # The `&` is a capture operator, It is used as a 
    # shorthand for creating anonymous functions
    # This line is equivalent to:
    # Agent.get(bucket, fn state -> Map.get(state, key) end)
    Agent.get(bucket, &Map.get(&1, key))
  end

  @doc """
  Puts the `value` for the fiven `key` in the `bucket`.
  """
  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end

  @doc """
  Deletes `key` from `bucket`.

  Returns the current value of `key`, if `key` exists.
  """
  def delete(bucket, key) do
    Agent.get_and_update(bucket, &Map.pop(&1, key))
  end
end
