defmodule PhxTalk.ChatMessages.ChatMessage do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "chat_messages" do
    field :message, :string

    belongs_to :user, PhxTalk.Accounts.User
    belongs_to :chat_room, PhxTalk.ChatRooms.ChatRoom

    timestamps(type: :utc_datetime)
  end

  @schema_attrs [:message, :chat_room_id, :user_id]

  @doc false
  def changeset(chat_message, attrs) do
    chat_message
    |> cast(attrs, @schema_attrs)
    |> validate_required(@schema_attrs)
  end
end
