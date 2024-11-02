defmodule PhxChatRoom.Repo.Migrations.CreateChatMessages do
  use Ecto.Migration

  def change do
    create table(:chat_messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :message, :text
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :chat_room_id, references(:chat_rooms, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:chat_messages, [:user_id])
    create index(:chat_messages, [:chat_room_id])
  end
end
