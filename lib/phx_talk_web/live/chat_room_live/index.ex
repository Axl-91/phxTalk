defmodule PhxTalkWeb.ChatRoomLive.Index do
  use PhxTalkWeb, :live_view

  alias PhxTalk.ChatRooms.ChatRoom
  alias PhxTalk.ChatMessages
  alias PhxTalk.ChatMessages.ChatMessage
  alias PhxTalk.ChatRooms
  alias Phoenix.Socket.Broadcast

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      PhxTalkWeb.Endpoint.subscribe("chat_room")
    end

    active_chat_room =
      ChatRooms.get_first_chat_room()
      |> default_chatroom_if_nil()

    chat_messages =
      active_chat_room.id
      |> ChatMessages.list_chat_messages_by_chat_room()

    socket =
      socket
      |> assign(:active_chat_room, active_chat_room)
      |> stream(:chat_messages, chat_messages)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    # Temporary solution
    socket = socket |> assign(:chat_rooms, ChatRooms.list_chat_rooms())
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("change_chatroom", %{"id" => chat_room_id}, socket) do
    new_active_chat_room = ChatRooms.get_chat_room!(chat_room_id)
    new_chat_messages = ChatMessages.list_chat_messages_by_chat_room(chat_room_id)

    socket =
      socket
      |> assign(:active_chat_room, new_active_chat_room)
      |> stream(:chat_messages, new_chat_messages, reset: true)
      |> push_event("scroll-down", %{})

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "delete_chatroom",
        %{"id" => chat_room_id},
        %{assigns: %{active_chat_room: %{id: chat_room_id}}} = socket
      ) do
    ChatRooms.get_chat_room!(chat_room_id)
    |> ChatRooms.delete_chat_room()

    active_chat_room =
      ChatRooms.get_first_chat_room()
      |> default_chatroom_if_nil()

    chat_messages =
      active_chat_room.id
      |> ChatMessages.list_chat_messages_by_chat_room()

    socket =
      socket
      |> assign(:active_chat_room, active_chat_room)
      |> assign(:chat_rooms, ChatRooms.list_chat_rooms())
      |> stream(:chat_messages, chat_messages, reset: true)

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_chatroom", %{"id" => chat_room_id}, socket) do
    ChatRooms.get_chat_room!(chat_room_id)
    |> ChatRooms.delete_chat_room()

    socket =
      socket
      |> assign(:chat_rooms, ChatRooms.list_chat_rooms())

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        %Broadcast{
          topic: "chat_room",
          event: "new_message",
          payload: %ChatMessage{chat_room_id: chat_room_id} = message
        },
        %{assigns: %{active_chat_room: %{id: chat_room_id}}} = socket
      ) do
    socket =
      socket
      |> stream_insert(:chat_messages, message)
      |> push_event("scroll-down", %{})

    {:noreply, socket}
  end

  @impl true
  def handle_info(%Broadcast{topic: "chat_room", event: "new_message"}, socket) do
    {:noreply, socket}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New ChatRoom")
    |> assign(:chat_room, %ChatRoom{})
  end

  defp apply_action(socket, :edit, params) do
    chat_room = ChatRooms.get_chat_room!(params["id"])

    socket
    |> assign(:page_title, "Edit ChatRoom")
    |> assign(:chat_room, chat_room)
  end

  defp apply_action(socket, _, _params) do
    socket
    |> assign(:page_title, "Home")
  end

  defp default_chatroom_if_nil(nil) do
    {:ok, chat_room} =
      ChatRooms.create_chat_room(%{name: "Default", description: "This is the default chatroom"})

    chat_room
  end

  defp default_chatroom_if_nil(chatroom), do: chatroom
end
