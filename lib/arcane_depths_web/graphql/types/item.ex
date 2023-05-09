defmodule ArcaneDepthsWeb.GraphQL.Types.Item do
  @moduledoc """
  An item. Can be in the inventory of a character or in a cell.
  """

  use Absinthe.Schema.Notation

  @desc "An item."
  object :item do
    @desc "The id of the item"
    field :id, :id

    @desc "The name of the item"
    field :name, :string

    @desc "The type of the item"
    field :type, :string

    # Add other fields as needed
  end
end
