defmodule Moviepass.Repo do
  use Ecto.Repo,
    otp_app: :moviepass,
    adapter: Ecto.Adapters.Postgres
end
