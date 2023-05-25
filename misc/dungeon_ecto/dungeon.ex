defmodule ArcaneDepths.Dungeon.Dungeon do
  use Ecto.Schema

  schema "dungeons" do

    field :id, :id

    field :name, :string

    has_many :layers, ArcaneDepths.Dungeon.DungeonLayer
  end
end
