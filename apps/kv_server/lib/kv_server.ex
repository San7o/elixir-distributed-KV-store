defmodule KVServer do
  require Logger

  @moduledoc """
  Documentation for `KVServer`.
  """
  
  @doc """
  Starts accepting connections on the given `port`.
  """
  def accept(port) do
    # The options below mean:
    #
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: :line` - receives data line by line
    # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
    # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
    #
    {:ok, socket} = :gen_tcp.listen(port,
                                       [:binary, packet: :line,
                                         active: false, reuseaddr: true])
    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  # Loops accepting client connections. For each accepted
  # connection it calls `serve/1`
  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    # Spawning one process per client connection, supervised
    {:ok, pid} = Task.Supervisor.start_child(KVServer.TaskSupervisor, fn -> serve(client) end)
    # The following line make the child process the "controlling
    # process" of the client socket. If we didn't do this, the
    # acceptor would bring down all the clients if it crashed
    # because sockets would be tied to the process that accepted
    # them (which is the default behavior).
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  # Loop that reads a line from the client and writes it back
  # to the socket (echo).
  defp serve(socket) do
    msg =
      # with will retrieve the value returned by the
      # right-side of <- and match it against the pattern
      # on the left side. If the value matches the pattern,
      # with moves on to the next expression. In case
      # there is no match, the non-matching value is returned.
      with {:ok, data} <- read_line(socket),
           {:ok, command} <- KVServer.Command.parse(data),
           do: KVServer.Command.run(command)

    write_line(socket, msg)
    serve(socket)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp write_line(socket, {:ok, text}) do
    :gen_tcp.send(socket, text)
  end

  defp write_line(socket, {:error, :unknown_command}) do
    :gen_tcp.send(socket, "UNKNOWN COMMAND\r\n")
  end

  defp write_line(_socket, {:error, :closed}) do
    exit(:shoudown)
  end

  defp write_line(socket, {:error, :not_found}) do
    :gen_tcp.send(socket, "NOT FOUND\r\n")
  end

  defp write_line(socket, {:error, error}) do
    :gen_tcp.send(socket, "ERROR\r\n")
    exit(error)
  end

end
