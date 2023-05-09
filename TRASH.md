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