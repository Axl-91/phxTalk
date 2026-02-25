defmodule PhxTalk.ChatRooms.ChatRoom do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "chat_rooms" do
    field :name, :string
    field :description, :string
    field :private, :boolean, default: false

    belongs_to :user, PhxTalk.Accounts.User
    has_many :chat_messages, PhxTalk.ChatMessages.ChatMessage
    many_to_many :users, PhxTalk.Accounts.User, join_through: "chat_room_users"

    timestamps(type: :utc_datetime)
  end

  @schema_attrs [:name, :description, :private, :user_id]

  @doc false
  def changeset(chat_room, attrs) do
    chat_room
    |> cast(attrs, @schema_attrs)
    |> validate_required([:name, :description, :private])
    |> put_assoc(:users, attrs["users"] || [])
  end
end
