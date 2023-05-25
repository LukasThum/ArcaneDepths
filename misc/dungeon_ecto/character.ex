defmodule ArcaneDepths.Dungeon.Character do
  use Ecto.Schema

  schema "characters" do
    field :id, :id
    field :name, :string

    belongs_to :cell, ArcaneDepthsWeb.Cell
    has_one :party, ArcaneDepthsWeb.Party, on_delete: :nullify
    has_one :inventory, ArcaneDepthsWeb.Inventory, on_delete: :nullify
  end
end
