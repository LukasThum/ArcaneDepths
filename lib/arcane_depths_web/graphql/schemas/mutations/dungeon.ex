defmodule ArcaneDepthsWeb.GraphQL.Schemas.Mutations.Dungeon do
  use Absinthe.Schema.Notation

  # Define the createDungeon mutation
  object :mutation do
    field :create_dungeon, :dungeon do
      arg(:name, non_null(:string))
      arg(:layers, list_of(:dungeon_layer_input))
      resolve(&ArcaneDepths.GraphQL.Resolvers.DungeonResolver.create_dungeon/3)
    end
  end
end
