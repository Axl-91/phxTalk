defmodule PhxTalkWeb.ChatComponents do
  use Phoenix.Component
  import PhxTalkWeb.CoreComponents

  use Phoenix.VerifiedRoutes,
    endpoint: PhxTalkWeb.Endpoint,
    router: PhxTalkWeb.Router

  @color_palette [
    "text-red-500",
    "text-green-500",
    "text-orange-500",
    "text-lime-500",
    "text-teal-500",
    "text-yellow-500",
    "text-purple-500",
    "text-indigo-500",
    "text-mauve-500",
    "text-pink-500"
  ]

  def chat_header(assigns) do
    ~H"""
    <div class="flex text-white justify-between items-center py-2 px-4 bg-gradient-to-r from-orange-700 to-orange-500 rounded-t-xl shadow-lg">
      <h1 class="text-3xl font-extrabold tracking-tighter italic drop-shadow-border">PhxTalk</h1>
      <.link patch={~p"/chat_room/new"}>
        <.button class="shadow-xl">New ChatRoom</.button>
      </.link>
    </div>
    """
  end

  def chat_rooms(assigns) do
    ~H"""
    <div class="float-left border-2 border-r-orange-900 border-orange-600 bg-gray-200 w-1/6 h-[600px]">
      <div class="flex flex-col h-full">
        <div class="h-1/2 overflow-y-auto">
          <h1 class="font-bold tracking-tighter bg-orange-500 border-b-2 border-orange-700 px-1">
            Public:
          </h1>
          <%= for chat_room <- public(@chat_rooms) do %>
            <% assigns = assign(assigns, :chat_room, chat_room) %>
            {show_chat_rooms(assigns)}
          <% end %>
        </div>
        <div class="h-1/2 tracking-tighter overflow-y-auto">
          <h1 class="font-bold bg-orange-500 border-y-2 border-orange-700 px-1">Private:</h1>
          <%= for chat_room <- private(@current_user, @chat_rooms) do %>
            <% assigns = assign(assigns, :chat_room, chat_room) %>
            {show_chat_rooms(assigns)}
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  defp show_chat_rooms(assigns) do
    ~H"""
    <% button_color =
      if @chat_room.id == @active_chat_room.id, do: "bg-gray-400", else: "hover:bg-gray-300" %>
    <button
      class={"flex w-full justify-between items-center overflow-y-scroll p-2 font-italic #{button_color} transition duration-500"}
      phx-click="change_chatroom"
      phx-value-id={@chat_room.id}
    >
      {@chat_room.name}
      <%= if @chat_room.user_id == @current_user.id do %>
        <div class="flex items-center space-x-2">
          <.link patch={~p"/chat_room/edit/#{@chat_room.id}"}>
            <i class="fas fa-edit text-violet-700 cursor-pointer transition-transform duration-300 hover:scale-125">
            </i>
          </.link>
          <i
            class="fas fa-trash-alt text-red-700 cursor-pointer transition-transform duration-300 hover:scale-125"
            phx-click="delete_chatroom"
            phx-value-id={@chat_room.id}
          >
          </i>
        </div>
      <% end %>
    </button>
    """
  end

  def chat_messages(assigns) do
    ~H"""
    <div
      id="messages_table"
      class="tabcontent w-5/6 border-2 border-l-0 border-orange-600 block float-left overflow-y-scroll h-[600px]"
      phx-hook="updateTable"
    >
      <%= if @active_chat_room do %>
        <div class="bg-zinc-200 py-1 px-1 border-b-2 border-zinc-500">
          <b class="text-orange-800 tracking-tight">Description:</b>
          <i>{@active_chat_room.description}</i>
        </div>
      <% end %>
      <div class="shadow-lg overflow-y-auto">
        <table class="w-full border-spacing-1">
          <tbody id="chat_messages" phx-update="stream">
            <tr :for={{id, chat_message} <- @streams.chat_messages} id={id}>
              <td class="px-2 py-1 border-t hover:bg-gray-200 flex justify-between">
                <div>
                  <% user_color = get_user_color(@current_user.email, chat_message.user.email) %>
                  <b class={user_color}>{chat_message.user.email}:</b>
                  <i class="text-gray-800 text-sm">{chat_message.message}</i>
                </div>
                <div class="text-gray-500 text-xs">
                  {get_time_chat(chat_message)}
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    """
  end

  defp get_user_color(email, email), do: "text-blue-500"

  defp get_user_color(_, email) do
    index = :erlang.phash2(email, length(@color_palette))
    Enum.at(@color_palette, index)
  end

  defp public(chat_rooms), do: Enum.filter(chat_rooms, fn cr -> not cr.private end)

  defp private(user, chat_rooms) do
    Enum.filter(chat_rooms, fn cr ->
      cr.private and Enum.any?(cr.users, fn u -> u.id == user.id end)
    end)
  end

  defp get_time_chat(chat_message) do
    inserted_at =
      chat_message.inserted_at
      |> DateTime.shift_zone!("America/Argentina/Buenos_Aires")

    today =
      DateTime.now!("America/Argentina/Buenos_Aires")
      |> NaiveDateTime.to_date()

    if NaiveDateTime.to_date(inserted_at) == today do
      "#{Calendar.strftime(inserted_at, "%H:%M")}"
    else
      "#{Calendar.strftime(inserted_at, "%d/%m/%Y %H:%M")}"
    end
  end
end
