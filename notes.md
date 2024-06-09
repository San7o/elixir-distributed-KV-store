# notes

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
