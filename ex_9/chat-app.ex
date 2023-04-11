defmodule Server do
  use GenServer
  require Logger

  # Start the chat server, initialize the Task Supervisor, and create an Agent to store clients.
  def start() do
    port = 4040
    Task.Supervisor.start_link(name: Server.TaskSupervisor)
    {:ok, socket} = start_link(port)
    Agent.start_link(fn -> [] end, name: :clients)
    {:ok, socket}
  end

  # Start the GenServer with the provided port.
  def start_link(port) do
    GenServer.start_link(__MODULE__, port)
  end

  # Initialize the server, start listening on the given port, and enter the loop_acceptor function.
  def init(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info("Server listening on port #{port}")
    Agent.start_link(fn -> [] end, name: :clients)
    loop_acceptor(socket)
    {:ok, %{}}
  end

  # Wait for incoming client connections, start serving them, and update the clients list in the Agent.
  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(Server.TaskSupervisor, fn -> serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    Agent.update(:clients, fn clients -> [client | clients] end)
    loop_acceptor(socket)
  end

  # Receive the client's name, log their connection, and enter the chat loop with the client.
  defp serve(socket) do
    clients = Agent.get(:clients, fn clients -> clients end)
    case :gen_tcp.recv(socket, 0) do
      {:ok, name_line} ->
        name = String.trim(name_line)
        Logger.info("#{name} joined the chat")
        chat_loop(socket, clients, name)
      {:error, _} ->
        Logger.info("Client disconnected")
    end
  end

  # Receive messages from a client, format them, broadcast the message to all clients, and continue the chat loop.
  defp chat_loop(socket, _clients, name) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, message} ->
        formatted_message = "#{name}: #{message}"
        current_clients = Agent.get(:clients, fn clients -> clients end)
        unless String.trim(message) == "", do: broadcast_message(formatted_message, current_clients)
        chat_loop(socket, current_clients, name)
      {:error, _} ->
        Logger.info("#{name} left the chat")
    end
  end

  #  Send the provided message to all clients in the list and print it to the server console.
  def broadcast_message(message, clients) do
    Enum.each(clients, fn client ->
      :gen_tcp.send(client, "#{message}\n")
    end)
    IO.puts("Server: #{message}")
  end
end

defmodule Client do
  require Logger

  # Connect to the server at the given host and port, and return the socket and port.
  def start(host, port) do
    {:ok, socket} = :gen_tcp.connect(host, port, [:binary, packet: :line, active: false])
    Logger.info("Connected to server at #{host}:#{port}")
    {socket, port}
  end

  # Send the client's name to the server.
  def set_name(socket, name) do
    :gen_tcp.send(socket, "#{name}\n")
  end

  # Send a message to the server.
  def send_message(socket, message) do
    :gen_tcp.send(socket, "#{message}\n")
  end

  # Receive messages from the server, filter out messages from the client, and continue receiving messages.
  def receive_messages(socket, name) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, message} ->
        unless String.trim(message) == "" || String.contains?(message, "#{name}: "), do: IO.puts(message)
        receive_messages(socket, name)
      {:error, :closed} ->
        Logger.info("Connection to server closed")
      {:error, reason} ->
        Logger.error("Error receiving message: #{inspect(reason)}")
    end
  end

  # Spawn a process to run the receive_messages function.
  def receive_messages_loop(socket, name) do
    spawn(fn ->
      receive_messages(socket, name)
    end)
  end

  # Prompt the user to input a message, send it to the server, and continue the message loop.
  def message_loop(socket, name) do
    message = IO.gets("> ") |> String.trim()


    case message do
      "exit" ->
        :ok
      _ ->
        send_message(socket, message)
        message_loop(socket, name)
    end
  end

  # Start the chat process by connecting to the server, setting the client's name, and entering the message and receive loops.
  def chat() do
    host = 'localhost'
    port = 4040
    IO.puts("To quit type (exit)")
    name = IO.gets("Enter your name: ") |> String.trim()
    {socket, _port} = start(host, port)

    set_name(socket, name)

    receive_messages_loop(socket, name)

    message_loop(socket, name)
  end
end
