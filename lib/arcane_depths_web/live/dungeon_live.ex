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

    log = []

    viewer = %{
      position: %{row: 1, cell: 1},
      direction: :east
    }

    {
      :ok,
      assign(
        socket,
        id: id,
        viewport: viewport,
        dungeon: dungeon(),
        viewer: viewer,
        log: log
      )
    }
  end

  def mount(_params, session, socket) do
    mount(%{"id" => "4"}, session, socket)
  end

  def handle_event("move", %{"action" => action}, socket) do
    log = socket.assigns.log
    case action do
      "turn-left" ->
        new_direction = get_new_direction_after_turn(socket.assigns.viewer.direction, :left)
        viewer = %{socket.assigns.viewer | direction: new_direction}
        log = ["player turned left to #{new_direction}" | log]
        {:noreply, assign(socket, viewer: viewer, log: log)}

      "turn-right" ->
        new_direction = get_new_direction_after_turn(socket.assigns.viewer.direction, :right)
        viewer = %{socket.assigns.viewer | direction: new_direction}
        log = ["player turned right to #{new_direction}" | log]
        {:noreply, assign(socket, viewer: viewer, log: log)}

      "go-forward" ->
        new_position = get_new_position_after_move(socket.assigns.viewer, :forward)
        viewer = %{socket.assigns.viewer | position: new_position}
        log = ["player moved forward to #{new_position.row}, #{new_position.cell}" | log]
        {:noreply, assign(socket, viewer: viewer, log: log)}

      "go-left" ->
        new_position = get_new_position_after_move(socket.assigns.viewer, :left)
        {:noreply, assign(socket, viewer: %{socket.assigns.viewer | position: new_position})}

      "go-backward" ->
        new_position = get_new_position_after_move(socket.assigns.viewer, :backward)
        {:noreply, assign(socket, viewer: %{socket.assigns.viewer | position: new_position})}

      "go-right" ->
        new_position = get_new_position_after_move(socket.assigns.viewer, :right)
        {:noreply, assign(socket, viewer: %{socket.assigns.viewer | position: new_position})}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_info(_info, socket) do
    {:noreply, socket}
  end

  # Helper functions for updating viewer's position and direction
  defp get_new_direction_after_turn(current_direction, turn) do
    directions = [:north, :east, :south, :west]
    index = Enum.find_index(directions, &(&1 == current_direction))

    new_index =
      case turn do
        :left -> index - 1
        :right -> index + 1
      end

    Enum.at(directions, rem(new_index, length(directions)))
  end

  defp get_new_position_after_move(viewer, direction) do
    %{row: row, cell: cell} = viewer.position

    movement_vectors = %{
      north: %{row: -1, cell: 0},
      south: %{row: 1, cell: 0},
      east: %{row: 0, cell: 1},
      west: %{row: 0, cell: -1}
    }

    move_vector =
      case direction do
        :forward ->
          movement_vectors[viewer.direction]

        :backward ->
          Map.update!(movement_vectors[viewer.direction], :row, &(-&1))
          |> Map.update!(:cell, &(-&1))

        :left ->
          %{
            row: movement_vectors[viewer.direction].cell,
            cell: -movement_vectors[viewer.direction].row
          }

        :right ->
          %{
            row: -movement_vectors[viewer.direction].cell,
            cell: movement_vectors[viewer.direction].row
          }
      end

    %{row: row + move_vector.row, cell: cell + move_vector.cell}
  end

  def wall_visible?(viewer, {row, cell}, direction) do
    case viewer.direction do
      :north -> row <= viewer.position.row && direction == :north
      :south -> row >= viewer.position.row && direction == :south
      :west -> cell <= viewer.position.cell && direction == :west
      :east -> cell >= viewer.position.cell && direction == :east
    end
  end

  def wall_style(viewport, {row_index, cell_index}, direction, viewer) do
    transformed_position = transformed_position(viewer, {row_index, cell_index})

    transform =
      case direction do
        :north ->
          """
          translateX(#{viewport.wall_left + transformed_position.cell * viewport.wall_width}px)
          translateY(0px)
          translateZ(#{-1 * transformed_position.row * viewport.wall_width}px)
          rotateX(0deg)
          rotateY(90deg)
          rotateZ(0deg)
          """

        :south ->
          """
          translateX(#{viewport.wall_left - transformed_position.cell * viewport.wall_width}px)
          translateY(0px)
          translateZ(#{1 * transformed_position.row * viewport.wall_width}px)
          rotateX(0deg)
          rotateY(-90deg)
          rotateZ(0deg)
          """

        :west ->
          """
          translateX(#{viewport.wall_left - transformed_position.row * viewport.wall_width}px)
          translateY(0px)
          translateZ(#{-1 * transformed_position.cell * viewport.wall_width}px)
          rotateX(0deg)
          rotateY(0deg)
          rotateZ(0deg)
          """

        :east ->
          """
          translateX(#{viewport.wall_left + transformed_position.row * viewport.wall_width}px)
          translateY(0px)
          translateZ(#{1 * transformed_position.cell * viewport.wall_width}px)
          rotateX(0deg)
          rotateY(180deg)
          rotateZ(0deg)
          """
      end

    """
    position: absolute;
    background-image: url(/images/wall-texture-001.png);
    transform: #{transform};
    """
  end

  def transformed_position(viewer, {row_index, cell_index}) do
    dx = row_index - viewer.position.row
    dy = cell_index - viewer.position.cell

    case viewer.direction do
      :north -> %{row: dx, cell: dy}
      :south -> %{row: -dx, cell: -dy}
      :west -> %{row: dy, cell: -dx}
      :east -> %{row: -dy, cell: dx}
    end
  end

  def dungeon2() do
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

  def dungeon() do
    [
      [
        %{north: true, south: false, west: true, east: false},
        %{north: true, south: false, west: false, east: false},
        %{north: true, south: false, west: false, east: false},
        %{north: true, south: false, west: false, east: true}
      ],
      [
        %{north: false, south: false, west: true, east: false},
        %{north: false, south: false, west: false, east: false},
        %{north: false, south: false, west: false, east: false},
        %{north: false, south: false, west: false, east: true}
      ],
      [
        %{north: false, south: false, west: true, east: false},
        %{north: false, south: false, west: false, east: false},
        %{north: false, south: false, west: false, east: false},
        %{north: false, south: false, west: false, east: true}
      ],
      [
        %{north: false, south: false, west: true, east: false},
        %{north: false, south: false, west: false, east: false},
        %{north: false, south: false, west: false, east: false},
        %{north: false, south: false, west: false, east: true}
      ],
      [
        %{north: false, south: true, west: true, east: false},
        %{north: false, south: true, west: false, east: false},
        %{north: false, south: true, west: false, east: false},
        %{north: false, south: true, west: false, east: true}
      ]
    ]
  end
end
