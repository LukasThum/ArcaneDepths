defmodule ArcaneDepths.Dungeon.Floor do
  use Ecto.Schema

  schema "floors" do
    field :id, :id
    field :type, :string

    belongs_to :cell, ArcaneDepthsWeb.Cell
  end
end
