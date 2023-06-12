defmodule Jellystone.Repo do
  use Ecto.Repo,
    otp_app: :jellystone,
    adapter: Ecto.Adapters.Postgres
end
