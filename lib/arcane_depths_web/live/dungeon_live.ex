defmodule ArcaneDepthsWeb.DungeonLive do
  use ArcaneDepthsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, name: "dungeon_001")}
  end
end
