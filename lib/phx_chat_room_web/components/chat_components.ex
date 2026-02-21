defmodule PhxChatRoomWeb.ChatComponents do
  use Phoenix.Component
  import PhxChatRoomWeb.CoreComponents

  use Phoenix.VerifiedRoutes,
    endpoint: PhxChatRoomWeb.Endpoint,
    router: PhxChatRoomWeb.Router

  def chat_header(assigns) do
    ~H"""
    <div class="flex text-white justify-between items-center py-2 px-4 bg-gradient-to-r from-orange-700 to-orange-500 rounded-t-xl shadow-lg">
      <h1 class="text-3xl font-extrabold tracking-tighter italic drop-shadow-border">PhxTalk</h1>
      <.link patch={~p"/chat_room/new"}>
        <.button class="shadow-xl">Create new ChatRoom</.button>
      </.link>
    </div>
    """
  end

  def chat_room_tabs(assigns) do
    ~H"""
    <div class="overflow-y-auto float-left border-2 border-r-orange-900 border-orange-600 bg-gray-200 w-1/10 h-[600px]">
      <%= for chat_room <- @chat_rooms do %>
        <% button_color =
          if chat_room.id == @active_chat_room.id, do: "bg-gray-400", else: "hover:bg-gray-300" %>
        <button
          class={"tab-button font-italic #{button_color} transition-colors duration-200 ease-in-out"}
          phx-click="change_chatroom"
          phx-value-id={chat_room.id}
        >
          {chat_room.name}
          <div class="flex items-center space-x-2">
            <.link patch={~p"/chat_room/edit/#{chat_room.id}"}>
              <i class="fas fa-edit text-violet-700 cursor-pointer"></i>
            </.link>
            <i
              class="fas fa-trash-alt text-red-700 cursor-pointer"
              phx-click="delete_chatroom"
              phx-value-id={chat_room.id}
            >
            </i>
          </div>
        </button>
      <% end %>
    </div>
    """
  end

  def chat_room_messages(assigns) do
    ~H"""
    <div id="messages_table" class="tabcontent border-2 border-orange-600" phx-hook="updateTable">
      <div class="chat_room_table shadow-lg">
        <table>
          <tbody id="chat_messages" phx-update="stream">
            <tr :for={{id, chat_message} <- @streams.chat_messages} id={id}>
              <td class="border-t hover:bg-gray-200">
                <b class="text-blue-500">{chat_message.user.email}:</b>
                <i class="text-gray-700 text-sm">{chat_message.message}</i>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    """
  end
end
