# Setup

First of all, you need to ensure all machines have a ~/.erlang.cookie file with exactly the same value. Then you need to guarantee epmd is running on a port that is not blocked (you can run epmd -d for debug info).

# Usage

Elixir ships with facilities to connect nodes and exchange information between them. In fact, we use the same concepts of processes, message passing and receiving messages when working in a distributed environment because Elixir processes are location transparent. This means that when sending a message, it doesn't matter if the recipient process is on the same node or on another node, the VM will be able to deliver the message in both cases.

In order to run distributed code, we need to start the VM with a name. The name can be short (when in the same network) or long (requires the full computer address). Let's start a new IEx session:

```bash
iex --sname foo
```

You can see now the prompt is slightly different and shows the node name followed by the computer name:

```elixir
Interactive Elixir - press Ctrl+C to exit (type h() ENTER for help)
iex(foo@jv)1>
```

My computer is named jv, so I see foo@jv in the example above, but you will get a different result. We will use foo@computer-name in the following examples and you should update them accordingly when trying out the code.

Let's define a module named Hello in this shell:

```elixir
defmodule Hello do
  def world, do: IO.puts "hello world"
end
```

If you have another computer on the same network with both Erlang and Elixir installed, you can start another shell on it. If you don't, you can start another IEx session in another terminal. In either case, give it the short name of bar:

```bash
iex --sname bar
```

Note that inside this new IEx session, we cannot access Hello.world/0:

```elixir
Hello.world
** (UndefinedFunctionError) function Hello.world/0 is undefined (module Hello is not available)
    Hello.world()
```

However, we can spawn a new process on foo@computer-name from bar@computer-name! Let's give it a try (where @computer-name is the one you see locally):

```elixir
Node.spawn_link(:"foo@computer-name", fn -> Hello.world() end)
#PID<9014.59.0>
hello world
```

Elixir spawned a process on another node and returned its PID. The code then executed on the other node where the Hello.world/0 function exists and invoked that function. Note that the result of "hello world" was printed on the current node bar and not on foo. In other words, the message to be printed was sent back from foo to bar. This happens because the process spawned on the other node (foo) knows all the output should be sent back to the original node!
