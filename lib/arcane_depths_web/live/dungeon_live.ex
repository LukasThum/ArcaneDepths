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
      perspective: 625
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
      half_wall_width: viewport_constants.wall_width / 2,
      half_wall_height: viewport_constants.wall_height / 2
    }

    viewport = Map.merge(viewport_calculation, viewport_constants)

    viewport
  end

  # recompile; ArcaneDepthsWeb.DungeonLive.numbered_rows(ArcaneDepthsWeb.DungeonLive.get_cells())
  def numbered_rows(cells) do
    middle = 3

    cells
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reverse()
    |> Enum.map(fn {row, i} ->
      {middle - i, numbered_cells(row)}
    end)
  end

  # recompile; ArcaneDepthsWeb.DungeonLive.numbered_cells()
  def numbered_cells(row) do
    middle = floor(length(row) / 2)

    row
    |> Enum.with_index()
    |> alternate_list()
    |> Enum.map(fn {cell, i} ->
      {i - middle, cell}
    end)
  end

  # recompile; ArcaneDepthsWeb.DungeonLive.alternate_list([1, 2, 3, 4, 5, 6, 7])
  def alternate_list([]), do: []
  def alternate_list([elem]), do: [elem]

  def alternate_list(list) do
    [hd | middle] = list

    case :lists.reverse(middle) do
      [] -> [hd]
      [last | middle_rev] -> [hd, last | alternate_list(:lists.reverse(middle_rev))]
    end
  end

  def get_wall_transform(viewport, x, y, "north") do
    """
    transform:
      translateX(#{x * viewport.wall_width}px)
      translateZ(#{y * viewport.wall_width - viewport.half_wall_width}px)
      translateY(#{0}px)
      rotateX(0deg)
      rotateY(0deg)
      rotateZ(0deg);
    """
  end

  def get_wall_transform(viewport, x, y, "west") do
    """
    transform:
      translateX(#{x * viewport.wall_width - viewport.half_wall_width}px)
      translateZ(#{y * viewport.wall_width}px)
      translateY(#{0}px)
      rotateX(0deg)
      rotateY(90deg)
      rotateZ(0deg);
    """
  end

  def get_wall_transform(viewport, x, y, "east") do
    """
    transform:
      translateX(#{x * viewport.wall_width + viewport.half_wall_width}px)
      translateZ(#{y * viewport.wall_width}px)
      translateY(#{0}px)
      rotateX(0deg)
      rotateY(90deg)
      rotateZ(0deg);
    """
  end

  def get_wall_transform(viewport, x, y, _) do
    ""
  end

  def get_cells() do
    cells = [
      [
        %{},
        %{},
        %{},
        %{
          walls: [
            %{
              direction: "west",
              type: "normal"
            },
            %{
              direction: "east",
              type: "normal"
            }
          ]},
        %{},
        %{},
        %{}
      ],
      [
        %{},
        %{},
        %{

          walls: [
            %{
              direction: "west",
              type: "normal"
            },
            %{
              direction: "east",
              type: "normal"
            }
          ]
        },
        %{},
        %{}
      ],
      [
        %{
          walls: [
            %{
              direction: "north",
              type: "normal"
            }
          ]
        },
        %{
        },
        %{
          walls: [
            %{
              direction: "north",
              type: "normal"
            }
          ]
        }
      ]
    ]

    cells
  end
end
