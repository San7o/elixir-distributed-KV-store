defmodule KV do
  # An application callback module implements the
  # `Application` behaviour and is used to start and
  # stop the application. The application callback module
  # is called from `mix.exs`
  use Application

  @moduledoc """
  Documentation for `KV`.
  """

  @impl true
  def start(_type, _args) do
    # Although we don't use the supervisor name below directly,
    # it can be useful when debugging or introspecting the system.
    KV.Supervisor.start_link(name: KV.Supervisor)
  end

  @doc """
  Hello world.

  ## Examples

      iex> KV.hello()
      :world

  """
  def hello do
    :world
  end
end
