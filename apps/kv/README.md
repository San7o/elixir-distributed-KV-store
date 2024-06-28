# KV

The backend KV store

# Notes

Before running any command, ensure you have a developement environment set up:
```bash
nix develop
```

## Create the project

This project as created with `mix` using the following command:

```bash
mix new kv --module KV
```

The file `mix.exs` contains the project configuration.

## Compile

You can compile the project with:
```bash
mix compile
```

## Run

To run the project, run:
```bash
iex -S mix
```

You can use the `recompile()` to compile again inside the shell.

## Test

You can run tests with:
```bash
mix test
```

## Automatic Formatter

You can run the formatter with:
```bash
mix format
```
The formatter configuration is located in `.formatter.exs`

## Observer

Run `iex -s mix` and the add the following lines:
```elixir
Mix.ensure_application!(:wx)             # Not necessary on Erlang/OTP 27+
Mix.ensure_application!(:runtime_tools)  # Not necessary on Erlang/OTP 27+
Mix.ensure_application!(:observer)
:observer.start()
```

# STD Lib

### Agent

**Simple abstraction around state.** The Agent module provides a basic server implementation that allows state to be retrieved and updated via a simple API.

### GenServer

**Do async operations in a client-server relation.** A GenServer is a process like any other Elixir process and it can be used to keep state, execute code asynchronously and so on. The advantage of using a generic server process (GenServer) implemented using this module is that it will have a standard set of interface functions and include functionality for tracing and error reporting. It will also fit into a supervision tree.

### Supervisor

A supervisor is a process which **supervises other processes**, which we refer to as child processes. Supervisors are used to build a hierarchical process structure called a supervision tree. Supervision trees provide fault-tolerance and encapsulate how our applications start and shutdown.

A dyncamic supervisor **starts children on demand dynamically** with `start_child`.

### Registry

In practice, if you find yourself in a position where you need a registry **to lookup dynamic processes**, you should use the Registry module provided as part of Elixir. It provides functionality similar to the one we have built using a GenServer + :ets while also being able to perform both writes and reads concurrently. It has been benchmarked to scale across all cores even on machines with 40 cores.


