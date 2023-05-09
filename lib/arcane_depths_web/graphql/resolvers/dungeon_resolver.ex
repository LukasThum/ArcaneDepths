defmodule ArcaneDepthsWeb.GraphQL.Resolvers.DungeonResolver do
  # import Ecto.Query

  # alias ArcaneDepths.Dungeon
  # alias ArcaneDepths.Repo

  # Resolve the dungeon query
  def get_dungeon(_, %{id: id}, _) do
    # case Repo.get(Dungeon, id) do
    #   nil -> {:error, "Dungeon not found"}
    #   dungeon -> {:ok, dungeon}
    # end
    {:ok, %{id: "123", name: "hallo"}}
  end

  # Resolve the createDungeon mutation
  # def create_dungeon(_, %{name: name, layers: layer_inputs}, _) do
  #   layers = layer_inputs |> Enum.map(&create_dungeon_layer/1)
  #   dungeon = %Dungeon{name: name, layers: layers}
  #   case Repo.insert(dungeon) do
  #     {:ok, _} -> {:ok, dungeon}
  #     {:error, changeset} -> {:error, changeset}
  #   end
  # end

  # Helper function to create a dungeon layer from an input
  defp create_dungeon_layer(layer_input) do
    # create a layer struct from the input
    # add validation and other logic as needed
  end
end
