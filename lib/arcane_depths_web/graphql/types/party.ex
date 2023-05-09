defmodule ArcaneDepthsWeb.GraphQL.Types.Party do
  @moduledoc """
  A party that can be inside a dungeon and on a specific cell.
  The party can consist of 1-4 characters.
  """

  use Absinthe.Schema.Notation

  @desc "A party inside a dungeon."
  object :party do
    @desc "The id of the party"
    field :id, :id

    @desc "The name of the party"
    field :name, :string

    @desc "The list of characters in the party"
    field :characters, list_of(:character)
  end
end
