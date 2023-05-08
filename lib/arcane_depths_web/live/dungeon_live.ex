defmodule ArcaneDepthsWeb.DungeonLive do
  use ArcaneDepthsWeb, :live_view

  def mount(%{"id" => id}, _session, socket) do
    topic = "dungeon:#{id}:tick"

    if connected?(socket) do
      ArcaneDepthsWeb.Endpoint.subscribe(topic)
    end

    viewport_constants = %{
      wall_width: 160,
      wall_height: 120,
      ceiling_ratio: 0.1,
      floor_ratio: 0.2,
      sidewall_ratio: 0.2,
      perspective: 280
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

    {
      :ok,
      assign(
        socket,
        id: id,
        viewport: viewport,
        dungeon: dungeon(),
      )
    }
  end

  def mount(_params, session, socket) do
    mount(%{"id" => "4"}, session, socket)
  end

  def handle_info(_info, socket) do
    {:noreply, socket}
  end

  def get_cell(dungeon, x, y) do
    Enum.at(Enum.at(dungeon, y), x)
  end

  def wall_between?(dungeon, x1, y1, x2, y2) do
    case {x2 - x1, y2 - y1} do
      {1, 0} -> get_cell(dungeon, x1, y1)[:east] || get_cell(dungeon, x2, y2)[:west]
      {-1, 0} -> get_cell(dungeon, x1, y1)[:west] || get_cell(dungeon, x2, y2)[:east]
      {0, 1} -> get_cell(dungeon, x1, y1)[:south] || get_cell(dungeon, x2, y2)[:north]
      {0, -1} -> get_cell(dungeon, x1, y1)[:north] || get_cell(dungeon, x2, y2)[:south]
      _ -> false
    end
  end


  def dungeon() do
    [
      [
        %{},
        %{},
        %{},
        %{},
        %{},
        %{north: true, south: true, west: true}
      ],
      [
        %{north: true, west: true},
        %{west: true},
        %{west: true},
        %{west: true},
        %{west: true},
        %{south: true}
      ],
      [
        %{north: true},
        %{},
        %{south: true},
        %{},
        %{},
        %{north: true, east: true, south: true}
      ],
      [
        %{north: true, east: true},
        %{east: true},
        %{east: true, south: true},
        %{},
        %{},
        %{}
      ]
    ]
  end
end
