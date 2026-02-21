defmodule PhxTalk.ChatRoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhxTalk.ChatRooms` context.
  """

  @doc """
  Generate a chat_room.
  """
  def chat_room_fixture(attrs \\ %{}) do
    {:ok, chat_room} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> PhxTalk.ChatRooms.create_chat_room()

    chat_room
  end
end
