defmodule PhxTalk.ChatMessagesTest do
  use PhxTalk.DataCase

  alias PhxTalk.ChatMessages

  describe "chat_messages" do
    alias PhxTalk.ChatMessages.ChatMessage

    import PhxTalk.AccountsFixtures
    import PhxTalk.ChatRoomsFixtures
    import PhxTalk.ChatMessagesFixtures

    @invalid_attrs %{"message" => nil}

    test "list_chat_messages/0 returns all chat_messages" do
      user = user_fixture()
      chat_room = chat_room_fixture()
      chat_message = chat_message_fixture(user, chat_room)

      assert ChatMessages.list_chat_messages() == [chat_message]
    end

    test "get_chat_message!/1 returns the chat_message with given id" do
      user = user_fixture()
      chat_room = chat_room_fixture()
      chat_message = chat_message_fixture(user, chat_room)

      assert ChatMessages.get_chat_message!(chat_message.id) == chat_message
    end

    test "create_chat_message/1 with valid data creates a chat_message" do
      user = user_fixture()
      chat_room = chat_room_fixture()
      valid_attrs = %{"message" => "some message"}

      assert {:ok, %ChatMessage{} = chat_message} =
               ChatMessages.create_chat_message(user, chat_room, valid_attrs)

      assert chat_message.message == "some message"
    end

    test "create_chat_message/1 with invalid data returns error changeset" do
      user = user_fixture()
      chat_room = chat_room_fixture()

      assert {:error, %Ecto.Changeset{}} =
               ChatMessages.create_chat_message(user, chat_room, @invalid_attrs)
    end

    test "update_chat_message/2 with valid data updates the chat_message" do
      user = user_fixture()
      chat_room = chat_room_fixture()
      chat_message = chat_message_fixture(user, chat_room)

      update_attrs = %{"message" => "some updated message"}

      assert {:ok, %ChatMessage{} = chat_message} =
               ChatMessages.update_chat_message(chat_message, update_attrs)

      assert chat_message.message == "some updated message"
    end

    test "update_chat_message/2 with invalid data returns error changeset" do
      user = user_fixture()
      chat_room = chat_room_fixture()
      chat_message = chat_message_fixture(user, chat_room)

      assert {:error, %Ecto.Changeset{}} =
               ChatMessages.update_chat_message(chat_message, @invalid_attrs)

      assert chat_message == ChatMessages.get_chat_message!(chat_message.id)
    end

    test "delete_chat_message/1 deletes the chat_message" do
      user = user_fixture()
      chat_room = chat_room_fixture()
      chat_message = chat_message_fixture(user, chat_room)

      assert {:ok, %ChatMessage{}} = ChatMessages.delete_chat_message(chat_message)
      assert_raise Ecto.NoResultsError, fn -> ChatMessages.get_chat_message!(chat_message.id) end
    end

    test "change_chat_message/1 returns a chat_message changeset" do
      user = user_fixture()
      chat_room = chat_room_fixture()
      chat_message = chat_message_fixture(user, chat_room)

      assert %Ecto.Changeset{} = ChatMessages.change_chat_message(chat_message)
    end
  end
end
