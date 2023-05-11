defmodule ArcaneDepths.Dungeon.Wall do
  use Ecto.Schema

  schema "walls" do
    field :id, :id
    field :type, :string
    field :direction, :string

    belongs_to :cell, ArcaneDepthsWeb.Cell
  end
end
