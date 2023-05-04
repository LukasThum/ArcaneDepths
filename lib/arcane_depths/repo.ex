defmodule ArcaneDepths.Repo do
  use Ecto.Repo,
    otp_app: :arcane_depths,
    adapter: Ecto.Adapters.Postgres
end
