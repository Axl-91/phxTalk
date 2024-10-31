defmodule PhxChatRoom.Repo do
  use Ecto.Repo,
    otp_app: :phx_chat_room,
    adapter: Ecto.Adapters.Postgres
end
