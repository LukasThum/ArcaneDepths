defmodule ArcaneDepthsWeb.GraphQL.Schema do
  use Absinthe.Schema

  alias ArcaneDepthsWeb.GraphQL.Resolvers.DungeonResolver

  # Import the types defined in other modules
  import_types(ArcaneDepthsWeb.GraphQL.Types.Cell)
  import_types(ArcaneDepthsWeb.GraphQL.Types.Character)
  import_types(ArcaneDepthsWeb.GraphQL.Types.Dungeon)
  import_types(ArcaneDepthsWeb.GraphQL.Types.DungeonLayer)
  import_types(ArcaneDepthsWeb.GraphQL.Types.Floor)
  import_types(ArcaneDepthsWeb.GraphQL.Types.Item)
  import_types(ArcaneDepthsWeb.GraphQL.Types.Party)
  import_types(ArcaneDepthsWeb.GraphQL.Types.Wall)

  query do
    @desc "get the whole dungeon"
    field :dungeon, :dungeon do
      arg(:id, non_null(:id))
      resolve(&DungeonResolver.get_dungeon/3)

      # can be nested
      # field :posts, list_of(:post) do
      #   arg :date, :date
      #   resolve &Resolvers.Content.list_posts/3
      # end
    end
  end
end
