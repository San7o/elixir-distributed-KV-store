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

## Notable Files

See `docs.md` for some basic notes on the official documentation

see `notes.md` for notes about building this project

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
