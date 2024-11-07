defmodule PhxChatRoomWeb.ChatRoomLive.Index do
  use PhxChatRoomWeb, :live_view

  alias PhxChatRoom.ChatMessages
  alias PhxChatRoom.ChatRooms
  alias Phoenix.Socket.Broadcast

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      PhxChatRoomWeb.Endpoint.subscribe("chat_room")
    end

    active_chat_room = ChatRooms.get_first_chat_room()

    chat_messages =
      active_chat_room.id
      |> ChatMessages.list_chat_messages_by_chat_room()

    socket =
      socket
      |> assign(:page_title, "Home")
      |> assign(:chat_rooms, ChatRooms.list_chat_rooms())
      |> assign(:active_chat_room, active_chat_room)
      |> stream(:chat_messages, chat_messages)
      |> assign(:input_message, nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("change_chatroom", %{"id" => chat_room_id}, socket) do
    new_active_chat_room = ChatRooms.get_chat_room!(chat_room_id)
    new_chat_messages = ChatMessages.list_chat_messages_by_chat_room(chat_room_id)

    socket =
      socket
      |> assign(:active_chat_room, new_active_chat_room)
      |> stream(:chat_messages, new_chat_messages, reset: true)

    {:noreply, socket}
  end

  @impl true
  def handle_info(%Broadcast{topic: "chat_room", event: "new_message", payload: message}, socket) do
    socket =
      socket
      |> stream_insert(:chat_messages, message)
      |> push_event("scroll-down", %{})

    {:noreply, socket}
  end

end
