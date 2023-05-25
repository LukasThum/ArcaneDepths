defmodule ArcaneDepths.Dungeon.Item do
  use Ecto.Schema

  schema "items" do
    field :id, :id
    field :name, :string

    belongs_to :cell, ArcaneDepthsWeb.Cell
  end
end
