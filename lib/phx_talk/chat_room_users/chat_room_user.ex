defmodule PhxTalk.ChatRoomUsers.ChatRoomUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chat_room_users" do
    belongs_to :chat_room, PhxTalk.ChatRooms.ChatRoom
    belongs_to :user, PhxTalk.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(chat_room_user, attrs) do
    chat_room_user
    |> cast(attrs, [])
    |> validate_required([:chat_room_id, :user_id])
  end
end
