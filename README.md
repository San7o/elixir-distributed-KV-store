# elixir-ristributed-KV-store

Umbrella project creates with
```bash
 mix new kv_umbrella --umbrella
 ```

# The Project

This application works as a distributed key-value store. We are going to organize key-value pairs into buckets and distribute those buckets across multiple nodes. We will also build a simple client that allows us to connect to any of those nodes and send requests such as:
```
CREATE shopping
OK

PUT shopping milk 1
OK

PUT shopping eggs 3
OK

GET shopping milk
1
OK

DELETE shopping eggs
OK
```
In order to build our key-value application, we are going to use three main tools:

- `OTP` (Open Telecom Platform) is a set of libraries that ships with Erlang. Erlang developers use OTP to build robust, fault-tolerant applications. In this chapter we will explore how many aspects from OTP integrate with Elixir, including supervision trees, event managers and more;

- `Mix` is a build tool that ships with Elixir that provides tasks for creating, compiling, testing your application, managing its dependencies and much more;

- `ExUnit` is a test-unit based framework that ships with Elixir.


# Developement environment

The use of `Nix` is strongly encouraged. To enter the developement environment, run:
```bash
nix develop
```

If you don't have nix, you must have both:
- `Elixir 1.15.0` onwards
- `Erlang/OTP 24` onwards

# Famous Frameworks

- `Phoenix` covers web applications

- `Ecto` communicates with database

- you can craft embedded software with `Nerves`

- `Nx` powers machine learning and AI projects

- `Membrane` assembles audio/video processing pipelines

- `Broadway` handles data ingestion and processing

- many more...

---

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

## Release
The configurarion for releases are in `mix.exs` in the root directory.
```bash
MIX_ENV=prod mix release foo
MIX_ENV=prod mix release bar

```

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


