defmodule ArcaneDepthsWeb.GraphQL.Resolvers.DungeonResolver do
  alias ArcaneDepthsWeb.GraphQL.Resolvers.DungeonLayerResolver

  def get_dungeon(_, _, _) do
    {
      :ok,
      get_dungeon()
    }
  end

  def get_dungeon() do
    %{
      id: "001",
      name: "test_dungeon_001",
      layers: DungeonLayerResolver.get_dungeon_layers("001")
    }
  end

  def view(_, %{dungeon_id: dungeon_id, x: x, y: y, direction: direction}, _) do
    dungeon = get_dungeon()
    dx = 3
    dy = 3

    cells =
      for i <- 0..(dungeon.width - 1), j <- 0..(dungeon.height - 1) do
        translate_cell(dungeon.cells[i][j], i, j, dx, dy, x, y, direction)
      end

    %{cells: cells}
  end

  defp translate_cell(cell, i, j, dx, dy, x, y, direction) do
    case direction do
      :north ->
        x_offset = i - dx
        y_offset = j - dy
        x_new = x + x_offset
        y_new = y + y_offset
        walls_new = remove_wall(cell.walls, "north")

        %{
          id: cell.id,
          walls: walls_new,
          floor: cell.floor,
          x: x_new,
          y: y_new
        }

      :south ->
        x_offset = dx - i
        y_offset = dy - j
        x_new = x + x_offset
        y_new = y + y_offset
        walls_new = remove_wall(cell.walls, "north")

        %{
          id: cell.id,
          walls: walls_new,
          floor: cell.floor,
          x: x_new,
          y: y_new
        }

      :east ->
        x_offset = dy - j
        y_offset = i - dx
        x_new = x + x_offset
        y_new = y + y_offset
        walls_new = remove_wall(cell.walls, "west")

        %{
          id: cell.id,
          walls: walls_new,
          floor: cell.floor,
          x: x_new,
          y: y_new
        }

      :west ->
        x_offset = j - dy
        y_offset = dx - i
        x_new = x + x_offset
        y_new = y + y_offset
        walls_new = remove_wall(cell.walls, "east")

        %{
          id: cell.id,
          walls: walls_new,
          floor: cell.floor,
          x: x_new,
          y: y_new
        }
    end
  end

  def remove_wall(walls, direction) do
    Enum.filter(walls, fn wall ->
      wall.direction != direction
    end)
  end
end
