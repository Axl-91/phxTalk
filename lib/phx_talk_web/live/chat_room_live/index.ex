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

    active_chat_room = ChatRooms.get_first_chat_room()

    chat_messages = get_chat_messages(active_chat_room)

    socket =
      socket
      |> assign(:active_chat_room, active_chat_room)
      |> assign(:chat_rooms, ChatRooms.list_chat_rooms())
      |> stream(:chat_messages, chat_messages)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
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
  def handle_event("delete_chatroom", %{"id" => chat_room_id}, socket) do
    ChatRooms.get_chat_room!(chat_room_id)
    |> ChatRooms.delete_chat_room()

    PhxTalkWeb.Endpoint.broadcast("chat_room", "delete_chatroom", chat_room_id)

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

  @impl true
  def handle_info(
        %Broadcast{topic: "chat_room", event: "new_chatroom", payload: new_chat_room},
        %{assigns: %{active_chat_room: active_chat_room, chat_rooms: chat_rooms}} = socket
      ) do
    socket =
      socket
      |> assign(:chat_rooms, chat_rooms ++ [new_chat_room])
      |> assign(
        :active_chat_room,
        if !active_chat_room do
          new_chat_room
        else
          active_chat_room
        end
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        %Broadcast{topic: "chat_room", event: "edit_chatroom", payload: updated_chat_room},
        socket
      ) do
    chat_rooms =
      socket.assigns.chat_rooms
      |> Enum.map(fn chat_room ->
        if chat_room.id == updated_chat_room.id do
          updated_chat_room
        else
          chat_room
        end
      end)

    {:noreply, socket |> assign(:chat_rooms, chat_rooms)}
  end

  @impl true
  def handle_info(
        %Broadcast{topic: "chat_room", event: "delete_chatroom", payload: deleted_id},
        %{assigns: %{active_chat_room: %{id: deleted_id}}} = socket
      ) do
    active_chat_room = ChatRooms.get_first_chat_room()

    chat_messages = get_chat_messages(active_chat_room)

    chat_rooms =
      socket.assigns.chat_rooms
      |> Enum.reject(fn chat_room -> chat_room.id == deleted_id end)

    socket =
      socket
      |> assign(:active_chat_room, active_chat_room)
      |> assign(:chat_rooms, chat_rooms)
      |> stream(:chat_messages, chat_messages, reset: true)

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        %Broadcast{topic: "chat_room", event: "delete_chatroom", payload: deleted_id},
        socket
      ) do
    chat_rooms =
      socket.assigns.chat_rooms
      |> Enum.reject(fn chat_room -> chat_room.id == deleted_id end)

    {:noreply, socket |> assign(:chat_rooms, chat_rooms)}
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

  defp get_chat_messages(nil), do: []

  defp get_chat_messages(active_chat_room) do
    active_chat_room.id
    |> ChatMessages.list_chat_messages_by_chat_room()
  end
end
