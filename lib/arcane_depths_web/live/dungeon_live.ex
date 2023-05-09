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
      position: %{x: 1, y: 1},
      direction: :east
    }

    dungeon = dungeon()

    {
      :ok,
      assign(
        socket,
        id: id,
        viewport: viewport,
        dungeon: dungeon,
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

    dungeon = socket.assigns.dungeon
    viewer_position = socket.assigns.dungeon
    viewer_direction = socket.assigns.dungeon

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
        log = ["player moved forward to #{new_position.x}, #{new_position.y}" | log]
        {:noreply, assign(socket, viewer: viewer, log: log)}

      "go-left" ->
        new_position = get_new_position_after_move(socket.assigns.viewer, :left)
        viewer = %{socket.assigns.viewer | position: new_position}
        log = ["player moved forward to #{new_position.x}, #{new_position.y}" | log]
        {:noreply, assign(socket, viewer: viewer, log: log)}

      "go-backward" ->
        new_position = get_new_position_after_move(socket.assigns.viewer, :backward)
        viewer = %{socket.assigns.viewer | position: new_position}
        log = ["player moved forward to #{new_position.x}, #{new_position.y}" | log]
        {:noreply, assign(socket, viewer: viewer, log: log)}

      "go-right" ->
        new_position = get_new_position_after_move(socket.assigns.viewer, :right)
        viewer = %{socket.assigns.viewer | position: new_position}
        log = ["player moved forward to #{new_position.x}, #{new_position.y}" | log]
        {:noreply, assign(socket, viewer: viewer, log: log)}

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
    %{x: x, y: y} = viewer.position

    movement_vectors = %{
      north: %{x: -1, y: 0},
      south: %{x: 1, y: 0},
      east: %{x: 0, y: 1},
      west: %{x: 0, y: -1}
    }

    move_vector =
      case direction do
        :forward ->
          movement_vectors[viewer.direction]

        :backward ->
          Map.update!(movement_vectors[viewer.direction], :x, &(-&1))
          |> Map.update!(:y, &(-&1))

        :left ->
          %{
            x: movement_vectors[viewer.direction].y,
            y: -movement_vectors[viewer.direction].x
          }

        :right ->
          %{
            x: -movement_vectors[viewer.direction].y,
            y: movement_vectors[viewer.direction].x
          }
      end

    %{x: x + move_vector.x, y: y + move_vector.y}
  end

  def wall_visible?(viewer, {x, y}, direction) do
    case viewer.direction do
      :north -> x <= viewer.position.x && direction == :north
      :south -> x >= viewer.position.x && direction == :south
      :west -> y <= viewer.position.y && direction == :west
      :east -> y >= viewer.position.y && direction == :east
    end
  end

  def floor_position(viewport, {x_index, y_index}, viewer) do
    transformed_position = transformed_position(viewer, {x_index, y_index})
    # transformed_direction = transform_direction(direction, viewer.direction)

    """
    transform:
      translateX(#{viewport.wall_left - transformed_position.y * viewport.wall_width}px)
      translateY(0px)
      translateZ(#{1 * transformed_position.x * viewport.wall_width}px)
      rotateX(0deg)
      rotateY(0deg)
      rotateZ(0deg);
    """
  end

  def wall_style(viewport, {x_index, y_index}, direction, viewer) do
    transformed_position = transformed_position(viewer, {x_index, y_index})
    transformed_direction = transform_direction(direction, viewer.direction)

    boiler = """
    position: absolute;
    image-rendering: pixelated;
    background-image: url(/images/wall-texture-001.png);
    """

    transform =
      case transformed_direction do
        :south ->
          """
          transform:
            translateX(#{viewport.wall_left - transformed_position.y * viewport.wall_width}px)
            translateY(0px)
            translateZ(#{1 * transformed_position.x * viewport.wall_width}px)
            rotateX(0deg)
            rotateY(0deg)
            rotateZ(0deg);
          """ <> boiler

        :west ->
          """
          transform:
            translateX(#{viewport.wall_left - transformed_position.x * viewport.wall_width}px)
            translateY(0px)
            translateZ(#{-1 * transformed_position.y * viewport.wall_width}px)
            rotateX(0deg)
            rotateY(90deg)
            rotateZ(0deg);
          """ <> boiler

        :east ->
          """
          transform:
            translateX(#{viewport.wall_left + transformed_position.x * viewport.wall_width}px)
            translateY(0px)
            translateZ(#{1 * transformed_position.y * viewport.wall_width}px)
            rotateX(0deg)
            rotateY(180deg)
            rotateZ(0deg);
          """ <> boiler

        _ ->
          "display: none;"
      end
  end

  def transformed_position(viewer, {x_index, y_index}) do
    dx = x_index - viewer.position.x
    dy = y_index - viewer.position.y

    case viewer.direction do
      :north -> %{x: dx, y: dy}
      :south -> %{x: -dx, y: -dy}
      :west -> %{x: dy, y: -dx}
      :east -> %{x: -dy, y: dx}
    end
  end

  def transform_direction(original_direction, viewer_direction) do
    case viewer_direction do
      :north ->
        original_direction

      :south ->
        case original_direction do
          :north -> :south
          :south -> :north
          :west -> :east
          :east -> :west
        end

      :west ->
        case original_direction do
          :north -> :west
          :south -> :east
          :west -> :south
          :east -> :north
        end

      :east ->
        case original_direction do
          :north -> :east
          :south -> :west
          :west -> :north
          :east -> :south
        end
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
