defmodule ArcaneDepthsWeb.GraphQL.Types.Cell do
  @moduledoc """
  A cell can be occupied by a monster, a player, or an item.
  each cell has 4 walls that can each be of various types.
  types of cells can be normal, gate, staircase etc.
  each cell has a ceiling that has a type like normal, trapdoor, etc.
  each cell has a floor that has a type like normal, puddle, trapdoor etc.
  """

  use Absinthe.Schema.Notation

  @desc "A cell in a dungeon layer."
  object :cell do
    @desc "The id of the layer"
    field :id, :id

    @desc "A list of walls in the cell"
    field :walls, list_of(:wall)

    @desc "The floor of the cell"
    field :floor, :floor

    @desc "The party in the cell"
    field :party, :party

    # @desc "The ceiling of the cell"
    # field :ceiling, :ceiling

  end
end
