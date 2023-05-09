defmodule ArcaneDepthsWeb.GraphQL.Schemas.Queries.Dungeon do
  use Absinthe.Schema.Notation

  # Define the dungeon query
  object :query do
    field :dungeon, :dungeon do
      arg(:id, non_null(:id))
      resolve(&ArcaneDepths.GraphQL.Resolvers.DungeonResolver.get_dungeon/3)
    end
  end
end
