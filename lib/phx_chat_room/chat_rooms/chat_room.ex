defmodule PhxChatRoom.ChatRooms.ChatRoom do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "chat_rooms" do
    field :name, :string
    field :description, :string

    has_many :chat_messages, PhxChatRoom.ChatMessages.ChatMessage

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat_room, attrs) do
    chat_room
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
