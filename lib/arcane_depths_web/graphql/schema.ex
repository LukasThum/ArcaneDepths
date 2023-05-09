defmodule ArcaneDepthsWeb.GraphQL.Schema do
  use Absinthe.Schema

  # Import the types defined in other modules
  import_types(ArcaneDepthsWeb.GraphQL.Types.Cell)
  import_types(ArcaneDepthsWeb.GraphQL.Types.DungeonLayer)
  import_types(ArcaneDepthsWeb.GraphQL.Types.Dungeon)

  # Define the root query object
  object :query do
    field :dungeon, :dungeon do
      arg(:id, non_null(:id))
      resolve(&ArcaneDepthsWeb.GraphQL.Resolvers.DungeonResolver.get_dungeon/3)
    end
  end

  # Define the schema
  def schema do
    # Define the root query and mutation
    Absinthe.Schema.Notation.compile(%{
      query: ArcaneDepthsWeb.GraphQL.Schema,
      mutation: ArcaneDepthsWeb.GraphQL.Schema
    })
  end
end
