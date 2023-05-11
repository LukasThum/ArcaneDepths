<style>
  .test {
    /* transform: perspective(300px) rotateX(30deg) rotateZ(30deg) rotateY(30deg); */
    transform: matrix3d(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
  }
</style>

<div class="w-full h-full">
  <svg id="dungeon-viewport" width="100%" height="100%">
    <image
      href={~p"/images/wall_001.png"}
      class="test"
    />
  </svg>
</div>

<!-- rotate(-10 50 100)   -->



  def handle_info(info, socket) do
    {:noreply, socket}
  end

  def test(wall, cam) do
    constant = 100

    distance =
      :math.sqrt(
        :math.pow(wall.x - cam.x, 2) + :math.pow(wall.y - cam.y, 2) +
          :math.pow(wall.z - cam.z, 2)
      )

    scale_x = constant / distance
    scale_y = constant / distance

    skew_angle = :math.atan2(wall.y - cam.y, wall.x - cam.x) * 180 / :math.pi()

    [
      scale_x,
      scale_y,
      skew_angle
    ]
  end



## git

```bash
git config --global http.postBuffer 157286400
```


i have this snippet from an svg:
```svg
<image href="wall.png" x="10" y="20" height="200" width="200" />
```

and i want to be able to set x1, y1, x2, y2 instead of x, y, width, height.
to do this i thought we could use the transform attribute of the image to
somehow emulate this.

```svg
    transform="rotate(-10 50 100)
               translate(-36 45.5)
               skewX(40)
               scale(1 0.5)">
```

is it possible to define an arbitrary polygon [(x1, y1) (x2, y2)] by using the definition of a box x, y, width, height and the transformations translate, skew, scale and rotate?


if i can define a polygon by x, y, width, height and use the transformations translate, skewX, skewY, scale and rotate, is it possible to make a function that will take any x1, y1, x2, y2 coordinates and give me the x, y, width height and transformations for that shape?


  def wall_between?(dungeon, x1, y1, x2, y2) do
    case {x2 - x1, y2 - y1} do
      {1, 0} -> get_cell(dungeon, x1, y1)[:east] || get_cell(dungeon, x2, y2)[:west]
      {-1, 0} -> get_cell(dungeon, x1, y1)[:west] || get_cell(dungeon, x2, y2)[:east]
      {0, 1} -> get_cell(dungeon, x1, y1)[:south] || get_cell(dungeon, x2, y2)[:north]
      {0, -1} -> get_cell(dungeon, x1, y1)[:north] || get_cell(dungeon, x2, y2)[:south]
      _ -> false
    end
  end

  && wall_visible?(@viewer, {row_index, cell_index}, direction)



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