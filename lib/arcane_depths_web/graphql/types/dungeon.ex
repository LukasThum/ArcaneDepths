defmodule ArcaneDepthsWeb.GraphQL.Types.Dungeon do
  @moduledoc """
  One dungeon consists of multiple levels (layers).
  """

  use Absinthe.Schema.Notation

  @desc "A representation of a dungeon."
  object :dungeon do

    @desc "id of a dungeon"
    field(:id, non_null(:string))

    @desc "name of a dungeon"
    field(:name, non_null(:string))

    @desc "A list of layers in the dungeon"
    field :layers, list_of(:dungeon_layer)
  end
end
