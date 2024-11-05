defmodule PhxChatRoomWeb.ChatRoomLive.Index do
  alias PhxChatRoom.ChatMessages
  alias PhxChatRoom.ChatRooms
  use PhxChatRoomWeb, :live_view

  def mount(_params, _session, socket) do
    active_chat_room = ChatRooms.get_first_chat_room()
    chat_messages = ChatMessages.list_chat_messages_by_chat_room(active_chat_room.id)

    socket =
      socket
      |> assign(:page_title, "Home")
      |> assign(:chat_rooms, ChatRooms.list_chat_rooms())
      |> assign(:active_chat_room, active_chat_room)
      |> assign(:chat_messages, chat_messages)
      |> assign(:input_message, nil)

    {:ok, socket}
  end

  def handle_event("change_chatroom", %{"id" => chat_room_id}, socket) do
    new_active_chat_room = ChatRooms.get_chat_room!(chat_room_id)
    new_chat_messages = ChatMessages.list_chat_messages_by_chat_room(chat_room_id)

    socket =
      socket
      |> assign(:active_chat_room, new_active_chat_room)
      |> assign(:chat_messages, new_chat_messages)

    {:noreply, socket}
  end

end
