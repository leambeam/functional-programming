## The chat app
1. Open a terminal window and navigate to the directory containing the chat-app.ex file.
2. Start an Elixir Interactive Shell by running:
    ```Elixir
    iex chat-app.ex
    ```
3. Start the server by running:
    ```Elixir
    Server.start()
    ```
4. Open another terminal window and navigate to the same directory.
5. Start another Interactive Shell by running:
    ```Elixir
    iex chat-app.ex
    ```
6. Start the client by running:
    ```Elixir
    Client.chat()
    ```
7. You can open as many clients as you like, each in a different terminal window. Once a client has connected to the server, you will be prompted to enter a name. After entering a name, you can send messages by typing them into the terminal and pressing enter.
8. Start chatting by entering messages in the client Interactive Shell.
9. To exit a client, type "exit" when prompted for a message and press Ctrl+C two times. To stop the server, press Ctrl+C two times in the terminal where it is running.
