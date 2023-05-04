defmodule ArcaneDepthsWeb.DungeonLive do
  use ArcaneDepthsWeb, :live_view

  use Tensor

  def mount(%{"id" => id}, _session, socket) do
    topic = "dungeon:#{id}:tick"

    if connected?(socket) do
      ArcaneDepthsWeb.Endpoint.subscribe(topic)
    end

    cam = %{ x: 200, y: 0, z: 200 }
    wall = %{ x: 0, y: 180, z: 0 }

    [
      scale_x,
      scale_y,
      skew_angle
    ] = test(cam, wall)

    {:ok, assign(socket,
      id: id,
      scale_x: scale_x,
      scale_y: scale_y,
      skew_angle: skew_angle
    )}
  end

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
end
