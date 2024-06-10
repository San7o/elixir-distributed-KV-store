# Elixir

## iex

Iex is the interactive mode, here you can type any Elixir expressions and get its results.

To wirte an hello world program, create a new file `hello_world.exs` with this line:
```elixir
IO.puts("Hello world from Elixir")
```

You can run the program with:
```bash
elixir hello_world.exs
```

If you use vim and you don't have syntax highlighting, you can install [vim-elixir](https://github.com/elixir-editors/vim-elixir)

# Types

The basic types are:
```
1          # integer
0x1F       # integer
1.0        # float
true       # boolean
:atom      # atom / symbol
"elixir"   # string
[1, 2, 3]  # list
{1, 2, 3}  # tuple
```
There are all the functions that you expect.

To read the documentation, you can use the `h` function:
```elixir
iex> h trunc/1
```
`h` works because it is defined in the `Kernel` module. All functions in the `Kernel` module are automatically imported into our namespace.

You can use `i` to get information about a value you have:
```elixir
iex>list = [1, 2, 3]
iex> i list
```

## Processes

In Elixir, all code runs inside processes. Processes are isolated from eachother, run concurrent to one another and communicate via message passing. Not to be confused with operating system processes.

```elixir
spawn(fn -> 1+2 end)
```

You can check if a process is alive with:
```elixir
Process.alive?(self())
```

You can send nmessage to a process with `send/2` and receive them with `receive/1`
```elixir
iex>parent = self()
#PID<0.41.0>
iex>spawn(fn -> send(parent, {:hello, self()}) end)
#PID<0.48.0>
iex>receive do
...>  {:hello, pid} -> "Got hello from #{inspect pid}"
...>end
"Got hello from #PID<0.48.0>"
```

### Links
You can spawn linked processes, this will propagate any error to the parent process. This is done with `spawn_link`
```elixir
spawn_link(fn -> raise "oops" end)
```
## Maintaining state with processes

Processes are often used to mantain state in the program. You can initialize some value in a process and update it with signals, something like this:
```elixir
defmodule KV do
  def start_link do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    receive do
      {:get, key, caller} ->
        send(caller, Map.get(map, key))
        loop(map)
      {:put, key, value} ->
        loop(Map.put(map, key, value))
    end
  end
end
```

```elixir
iex>{:ok, pid} = KV.start_link()
{:ok, #PID<0.62.0>}
iex>send(pid, {:get, :hello, self()})
{:get, :hello, #PID<0.41.0>}
iex>flush()
nil
:ok
```

Elixir provides `Agent`s which are abstractions around state.
```elixir
iex>{:ok, pid} = Agent.start_link(fn -> %{} end)
{:ok, #PID<0.72.0>}
iex>Agent.update(pid, fn map -> Map.put(map, :hello, :world) end)
:ok
iex>Agent.get(pid, fn map -> Map.get(map, :hello) end)
:world
```

## Protocols

Protocols are basically interfaces
```elixir
defprotocol Size do
  @doc "Calculates the size (and not the length!) of a data structure"
  def size(data)
end

defimpl Size, for: BitString do
  def size(string), do: byte_size(string)
end

defimpl Size, for: Map do
  def size(map), do: map_size(map)
end

defimpl Size, for: Tuple do
  def size(tuple), do: tuple_size(tuple)
end
```

You can define protocols for any type with `Any`:
```elixir
defimpl Size, for: Any do
  def size(_), do: 0
end
```
and you need to derive it:
```elixir
defmodule OtherUser do
  @derive [Size]
  defstruct [:name, :age]
end
```
You can fallback to any if no implementation has been found:
```elixir
defprotocol Size do
  @fallback_to_any true
  def size(data)
end
```
but you may want to raise an error if a protocol is not implemented.

Some default protocols are `Enumerable`. `String.Chars`, `Inspect`

## Exceptions

You can define and raise exceptions like this:
```elixir
defmodule MyError do
  defexception message: "default message"
end
raise MyError
```

Errors can be rescued useng `try/rescue` construct:
```elixir
try do
  raise "oops"
rescue
  e in RuntimeError -> e
end
```
But most of the error handling is node via return atoms sile `:ok` and `:error`. In many libraries, there are variants of functions with a `!` at the end that raise an exception instead of returning an atom (for example `File.read!()`

### Fail fast / let ti crash

"fail fast" / "let it crash" is a way of saying that, when something _unexpected happens, it is best to start from scratch within a new process, freshly started by a supervisor, rather than blindly trying to rescue all possible error cases without the full context of when and how they can happen.

## Breakpoints
When using IEx, you may pass `--dbg pry` as an option to "stop" the code execution where the dbg call is:
```elixir
# In dbg_pipes.exs
__ENV__.file
|> String.split("/", trim: true)
|> List.last()
|> File.exists?()
|> dbg()
```

```elixir
iex --dbg pry
```

You can get a windows with a lot of informations with:
```elixir
:observer.start()
```


## links
[Enumeration cheatsheet](https://hexdocs.pm/elixir/enum-cheat.html)

[Introduction](https://hexdocs.pm/elixir/basic-types.html)
