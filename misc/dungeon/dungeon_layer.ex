defmodule ArcaneDepths.Dungeon.DungeonLayer do
  use Ecto.Schema

  schema "dungeon_layers" do

    field :id, :id

    belongs_to :dungeon, ArcaneDepths.Dungeon.Dungeon

    has_many :cells, ArcaneDepthsWeb.Cell

  end
end
