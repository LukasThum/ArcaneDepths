defmodule ArcaneDepthsWeb.DungeonLive do
  use ArcaneDepthsWeb, :live_view

  use Tensor

  def mount(%{"id" => id}, _session, socket) do
    topic = "dungeon:#{id}:tick"

    if connected?(socket) do
      ArcaneDepthsWeb.Endpoint.subscribe(topic)
    end

    {
      :ok,
      assign(
        socket,
        id: id
      )
    }
  end

  def mount(_params, session, socket) do
    mount(%{"id" => "4"}, session, socket)
  end


  def handle_info(_info, socket) do
    {:noreply, socket}
  end
end
