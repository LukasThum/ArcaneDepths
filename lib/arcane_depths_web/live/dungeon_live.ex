defmodule ArcaneDepthsWeb.DungeonLive do
  use ArcaneDepthsWeb, :live_view

  def mount(%{"id" => id}, _session, socket) do
    topic = "dungeon:#{id}:tick"

    if connected?(socket) do
      ArcaneDepthsWeb.Endpoint.subscribe(topic)
    end

    {
      :ok,
      assign(
        socket,
        id: id,
        viewport: get_viewport(),
        cells: get_cells()
      )
    }
  end

  def mount(_params, session, socket) do
    mount(%{"id" => "4"}, session, socket)
  end

  def handle_event(_params, _session, socket) do
    {:noreply, socket}
  end

  def handle_info(_info, socket) do
    {:noreply, socket}
  end

  def get_viewport() do
    viewport_constants = %{
      wall_width: 160,
      wall_height: 120,
      ceiling_ratio: 0.1,
      floor_ratio: 0.2,
      sidewall_ratio: 0.2,
      perspective: 428
    }

    viewport_calculation = %{
      width:
        viewport_constants.wall_width +
          2 * (viewport_constants.wall_width * viewport_constants.sidewall_ratio),
      height:
        viewport_constants.wall_height +
          viewport_constants.wall_height * viewport_constants.ceiling_ratio +
          viewport_constants.wall_height * viewport_constants.floor_ratio,
      wall_left: -1 * (viewport_constants.wall_width / 2),
      wall_right: viewport_constants.wall_width / 2,
      half_wall_width: viewport_constants.wall_width / 2
    }

    viewport = Map.merge(viewport_calculation, viewport_constants)

    viewport
  end

  # recompile; ArcaneDepthsWeb.DungeonLive.numbered_rows(ArcaneDepthsWeb.DungeonLive.get_cells())
  def numbered_rows(cells) do
    cells
    |> Enum.with_index()
    |> Enum.map(fn {row, i} ->
      {i , numbered_cells(row)}
    end)
  end

  # recompile; ArcaneDepthsWeb.DungeonLive.numbered_cells()
  def numbered_cells(row) do
    middle = round(length(row) / 2) -1

    row
    |> Enum.with_index()
    |> Enum.map(fn {cell, i} ->
      {i - middle, cell}
    end)
  end

  def get_cells() do
    cells = [
      [
        %{},
        %{},
        %{},
        %{},
        %{},
        %{},
        %{},
      ],
      [
        %{},
        %{},
        %{},
        %{},
        %{},
      ],
      [
        %{},
        %{},
        %{},
      ],
    ]


    cells
  end
end
