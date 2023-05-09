defmodule ArcaneDepthsWeb.GraphQL.Types.DungeonLayer do
  @moduledoc """
  Each layer consists of a 2d grid of cells.
  """

  use Absinthe.Schema.Notation

  @desc "A layer or level of a dungeon."
  object :dungeon_layer do
    @desc "The id of the layer"
    field :id, :id

    @desc "A list of cells in the layer"
    field :cells, list_of(list_of(:cell))
  end
end
