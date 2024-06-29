defmodule KV.RouterTest do
  use ExUnit.Case, async: true

  # This test is tagged as distributed
  # In `test_helper.exs`, we are excluding distributed tests
  # when the node is not alive
  # Use 
  # `elixir --sname foo -S mix test` and
  # `elixir --sname foo -S mix test` to run the tests
  @tag :distributed

  test "route requiests across nodes" do
    assert KV.Router.route("hello", Kernel, :node, []) ==
      :"foo@nixos"
    assert KV.Router.route("world", Kernel, :node, []) ==
      :"bar@nixos"
  end

  test "raises on unknown entries" do
    assert_raise RuntimeError, ~r/could not find entry/, fn ->
      KV.Router.route(<<0>>, Kernel, :node, [])
    end
  end
end
