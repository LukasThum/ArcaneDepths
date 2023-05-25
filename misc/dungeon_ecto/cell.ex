defmodule ArcaneDepths.Dungeon.Cell do
  use Ecto.Schema

  schema "cells" do
    field :id, :id

    belongs_to :layer, ArcaneDepthsWeb.DungeonLayer

    has_many :walls, ArcaneDepthsWeb.Wall
    has_one :ceiling, ArcaneDepthsWeb.Ceiling
    has_one :floor, ArcaneDepthsWeb.Floor

    belongs_to :item, ArcaneDepthsWeb.Item, on_replace: :update
    has_one :character, ArcaneDepthsWeb.Character, on_replace: :update
  end
end
