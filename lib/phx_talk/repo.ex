defmodule PhxTalk.Repo do
  use Ecto.Repo,
    otp_app: :phx_talk,
    adapter: Ecto.Adapters.Postgres
end
