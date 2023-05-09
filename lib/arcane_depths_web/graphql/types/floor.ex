defmodule ArcaneDepthsWeb.GraphQL.Types.Floor do
  @moduledoc """
  A floor can be of various types like normal, puddle, trapdoor, etc.
  Each slot holds a list of items.
  The list is ordered and determines which item is rendered first.
  """

  use Absinthe.Schema.Notation

  @desc "A floor of a dungeon cell."
  object :floor do
    @desc "The id of the floor"
    field :id, :id

    @desc "The type of the floor"
    field :type, :string

    @desc "The first item slot on the floor, located in the North-West quadrant"
    field :slot_1, list_of(:item)

    @desc "The second item slot on the floor, located in the North-East quadrant"
    field :slot_2, list_of(:item)

    @desc "The third item slot on the floor, located in the South-West quadrant"
    field :slot_3, list_of(:item)

    @desc "The fourth item slot on the floor, located in the South-East quadrant"
    field :slot_4, list_of(:item)
  end
end
