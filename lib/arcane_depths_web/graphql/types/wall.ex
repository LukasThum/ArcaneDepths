defmodule ArcaneDepthsWeb.GraphQL.Types.Wall do
  @moduledoc """
  A wall can be of various types like normal, door, gate, etc.
  Walls face a certain direction like north, south, east, west.
  """

  use Absinthe.Schema.Notation

  @desc "A wall of a dungeon cell."
  object :wall do
    @desc "The id of the wall"
    field :id, :id

    @desc "The type of the wall"
    field :type, :string

    @desc "The direction the wall faces"
    field :direction, :string
  end
end
