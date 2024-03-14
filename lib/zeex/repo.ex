defmodule Zeex.Repo do
  use Ecto.Repo,
    otp_app: :zeex,
    adapter: Ecto.Adapters.Postgres
end
