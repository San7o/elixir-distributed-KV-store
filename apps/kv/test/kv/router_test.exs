defmodule KV.RouterTest do
  use ExUnit.Case

  # Setup the routing table
  setup_all do
    current = Application.get_env(:kv, :routing_table)

    Application.put_env(:kv, :routing_table, [
      {?a..?m, :foo@nixos},
      {?n..?z, :bar@nixos}
    ])

    on_exit(fn -> Application.put_env(:kv, :routing_table, current) end)
  end

  # This test is tagged as distributed
  # In `test_helper.exs`, we are excluding distributed tests
  # when the node is not alive
  # Use 
  # `elixir --sname foo -S mix test` and
  # `elixir --sname foo -S mix test` to run the tests
  @tag :distributed
  test "route requiests across nodes" do
    assert KV.Router.route("hello", Kernel, :node, []) ==
             :foo@nixos

    assert KV.Router.route("world", Kernel, :node, []) ==
             :bar@nixos
  end

  test "raises on unknown entries" do
    assert_raise RuntimeError, ~r/could not find entry/, fn ->
      KV.Router.route(<<0>>, Kernel, :node, [])
    end
  end
end
