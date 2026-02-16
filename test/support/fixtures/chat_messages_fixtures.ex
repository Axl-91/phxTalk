defmodule PhxChatRoom.ChatMessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhxChatRoom.ChatMessages` context.
  """

  @doc """
  Generate a chat_message.
  """
  def chat_message_fixture(user, chat_room) do
    attrs = %{"message" => "some message"}

    {:ok, chat_message} =
      PhxChatRoom.ChatMessages.create_chat_message(user, chat_room, attrs)

    chat_message
  end
end
