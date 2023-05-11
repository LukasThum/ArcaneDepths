defmodule ArcaneDepthsWeb.GraphQL.Resolvers.DungeonLayerResolver do

  alias ArcaneDepthsWeb.GraphQL.Resolvers.CellResolver

  def get_dungeon_layers(id) do
    dungeon = [
      %{
        id: "001",
        cells: CellResolver.get_cells("001")
      }
    ]

   # IO.inspect(dungeon)

    dungeon
  end
end
