defmodule KV.Bucket do
  use Agent

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
end