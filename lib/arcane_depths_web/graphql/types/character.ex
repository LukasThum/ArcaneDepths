defmodule ArcaneDepthsWeb.GraphQL.Types.Character do
  @moduledoc """
  A character in a party.
  The character occupies a specific slot in a cell.
  """

  use Absinthe.Schema.Notation

  @desc "A character in a party."
  object :character do
    @desc "The id of the character"
    field :id, :id

    @desc "The name of the character"
    field :name, :string

    @desc "The slot in the cell that the character occupies"
    field :slot, :integer

    @desc "A 2D grid representing the character's inventory. Items can be placed in this grid."
    field :inventory, list_of(list_of(:item))

    @desc "The width of the character's inventory"
    field :inventory_width, :integer

    @desc "The height of the character's inventory"
    field :inventory_height, :integer

    # Add other fields as needed
  end
end
