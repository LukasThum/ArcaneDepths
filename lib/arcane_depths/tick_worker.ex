defmodule ArcaneDepths.TickWorker do
  use GenServer

  # Start the GenServer
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  # Initialize the GenServer state
  def init(:ok) do
    # Schedule the first tick
    schedule_tick()

    {:ok, %{}}
  end

  # Handle the tick message
  def handle_info(:tick, state) do
    # Perform the tick operation for all users in all dungeons
    tick_users_in_dungeons()

    # Schedule the next tick
    schedule_tick()

    {:noreply, state}
  end

  defp schedule_tick() do
    # Set a delay for the next tick (e.g., 1000 milliseconds)
    delay = 1_000
    Process.send_after(self(), :tick, delay)
  end

  defp tick_users_in_dungeons() do
    # dungeons = ArcaneDepths.Dungeon.get_all_dungeons()
    dungeons = [%{id: "4"}]

    for dungeon <- dungeons do
      topic = "dungeon:#{dungeon.id}:tick"
      ArcaneDepthsWeb.Endpoint.broadcast(topic, "tick", %{})
    end
  end
end
