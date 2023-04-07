defmodule Timer do
  use GenServer

  ## Client API


  # Start the registry.

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end


  # Send a request to the GenServer to start the timer.

  def start_timer(pid, period, fun) do
    GenServer.call(pid, {:start_timer, period, fun})
  end


  # Send a request to the GenServer to stop the timer.

  def cancel_timer(pid) do
    GenServer.call(pid, :cancel_timer)
  end

  ## Server


  # Initialize GenServer.

  def init(_) do
    {:ok, nil}
  end


  # Handle :start_timer call.

  def handle_call({:start_timer, period, fun}, _from, state) do
    {:noreply, _} = cancel_timer_is_set(state)
    timer_ref = Process.send_after(self(), :trigger, period)
    {:reply, :ok, %{timer_ref: timer_ref, period: period, fun: fun}}
  end


  # Handle :cancel_timer call.

  def handle_call(:cancel_timer, _from, state) do
    {:noreply, new_state} = cancel_timer_is_set(state)
    {:reply, :ok, new_state}
  end


  # Handle :trigger message.

  def handle_info(:trigger, state) do
    case state.fun.() do
      :cancel ->
        {:noreply, nil}

      :ok ->
        timer_ref = Process.send_after(self(), :trigger, state.period)
        {:noreply, %{state | timer_ref: timer_ref}}
    end
  end

  # Utilities

  defp cancel_timer_is_set(nil) do
    {:noreply, nil}
  end

  defp cancel_timer_is_set(state) do
    Process.cancel_timer(state.timer_ref)
    {:noreply, nil}
  end
end


defmodule Timer_test do
  def timer_test(Timer) do
    word = IO.gets("Enter the phrase you want to print: ") |> String.trim()
    time = IO.gets("For how long you want the timer to trigger? Note: (1000 -- 1 second): ") |> String.trim() |> String.to_integer()
    {:ok, timer} = Timer.start_link([])

    Timer.start_timer(timer, 1000, fn ->
      IO.puts(word)
      :ok
    end)
    :timer.sleep(time)

    # Timer.cancel_timer(timer)
  end
end

Timer_test.timer_test(Timer)
