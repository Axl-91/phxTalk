defmodule PhxTalk.Repo.Migrations.AddPrivateToChatRoomAndCreateChatRoomUsers do
  use Ecto.Migration

  def change do
    alter table(:chat_rooms) do
      add :private, :boolean, default: false
    end

    create table(:chat_room_users) do
      add :chat_room_id, references(:chat_rooms, on_delete: :delete_all, type: :binary_id)
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      timestamps()
    end

    create unique_index(:chat_room_users, [:chat_room_id, :user_id])
  end
end
