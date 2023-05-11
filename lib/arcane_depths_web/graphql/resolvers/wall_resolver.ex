defmodule ArcaneDepthsWeb.GraphQL.Resolvers.WallResolver do
  import Ecto

  def get_walls(0, _) do
    [
      %{
        id: Ecto.UUID.generate,
        type: "solid",
        direction: "east"
      },
    ]
  end

  def get_walls(4, _) do
    [
      %{
        id: Ecto.UUID.generate,
        type: "solid",
        direction: "west"
      },
    ]
  end


  def get_walls(_, 0) do
    [
      %{
        id: Ecto.UUID.generate,
        type: "solid",
        direction: "north"
      },
    ]
  end

  def get_walls(_, 4) do
    [
      %{
        id: Ecto.UUID.generate,
        type: "solid",
        direction: "south"
      },
    ]
  end

  def get_walls(x, y) do
    []
  end
end
