defmodule ArcaneDepthsWeb.GraphQL.Resolvers.CellResolver do
  alias ArcaneDepthsWeb.GraphQL.Resolvers.FloorResolver
  alias ArcaneDepthsWeb.GraphQL.Resolvers.WallResolver
  # alias ArcaneDepthsWeb.GraphQL.Resolvers.PartyResolver

  sample = """
  ####
  #  #
  # ##
  #  #
  ####
  """

  def get_cells(_layer_id) do
    [
      %{
        id: "001",
        walls: WallResolver.get_walls(0, 0),
        floor: FloorResolver.get_floor("001")
      },
      %{
        id: "002",
        walls: WallResolver.get_walls(1, 0),
        floor: FloorResolver.get_floor("002")
      },
      %{
        id: "003",
        walls: WallResolver.get_walls(2, 0),
        floor: FloorResolver.get_floor("003")
      },
      %{
        id: "004",
        walls: WallResolver.get_walls(3, 0),
        floor: FloorResolver.get_floor("004")
      },
      %{
        id: "005",
        walls: WallResolver.get_walls(4, 0),
        floor: FloorResolver.get_floor("005")
      },
      %{
        id: "006",
        walls: WallResolver.get_walls(0, 1),
        floor: FloorResolver.get_floor("006")
      },
      %{
        id: "007",
        walls: WallResolver.get_walls(1, 1),
        floor: FloorResolver.get_floor("007")
      },
      %{
        id: "008",
        walls: WallResolver.get_walls(2, 1),
        floor: FloorResolver.get_floor("008")
      },
      %{
        id: "009",
        walls: WallResolver.get_walls(3, 1),
        floor: FloorResolver.get_floor("009")
      },
      %{
        id: "010",
        walls: WallResolver.get_walls(4, 1),
        floor: FloorResolver.get_floor("010")
      },
      %{
        id: "011",
        walls: WallResolver.get_walls(0, 2),
        floor: FloorResolver.get_floor("011")
      },
      %{
        id: "012",
        walls: WallResolver.get_walls(1, 2),
        floor: FloorResolver.get_floor("012")
      },
      %{
        id: "013",
        walls: WallResolver.get_walls(2, 2),
        floor: FloorResolver.get_floor("013")
      },
      %{
        id: "014",
        walls: WallResolver.get_walls(3, 2),
        floor: FloorResolver.get_floor("014")
      },
      %{
        id: "015",
        walls: WallResolver.get_walls(4, 2),
        floor: FloorResolver.get_floor("015")
      },
      %{
        id: "016",
        walls: WallResolver.get_walls(0, 3),
        floor: FloorResolver.get_floor("016")
      },
      %{
        id: "017",
        walls: WallResolver.get_walls(1, 3),
        floor: FloorResolver.get_floor("017")
      },
      %{
        id: "018",
        walls: WallResolver.get_walls(2, 3),
        floor: FloorResolver.get_floor("018")
      },
      %{
        id: "019",
        walls: WallResolver.get_walls(3, 3),
        floor: FloorResolver.get_floor("019")
      },
      %{
        id: "020",
        walls: WallResolver.get_walls(4, 3),
        floor: FloorResolver.get_floor("020")
      },
      %{
        id: "021",
        walls: WallResolver.get_walls(0, 4),
        floor: FloorResolver.get_floor("021")
      },
      %{
        id: "022",
        walls: WallResolver.get_walls(1, 4),
        floor: FloorResolver.get_floor("022")
      },
      %{
        id: "023",
        walls: WallResolver.get_walls(2, 4),
        floor: FloorResolver.get_floor("023")
      },
      %{
        id: "024",
        walls: WallResolver.get_walls(3, 4),
        floor: FloorResolver.get_floor("024")
      },
      %{
        id: "025",
        walls: WallResolver.get_walls(4, 4),
        floor: FloorResolver.get_floor("025")
      }
    ]
  end
end
