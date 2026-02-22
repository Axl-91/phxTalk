defmodule PhxTalk.Repo.Migrations.AddUserIdToChatRoom do
  use Ecto.Migration

  def change do
    alter table(:chat_rooms) do
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
    end

    create index(:chat_rooms, [:user_id])
  end
end
