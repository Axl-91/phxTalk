defmodule PhxChatRoomWeb.ChatRoomLive.FormComponent do
  use PhxChatRoomWeb, :live_component

  alias PhxChatRoom.ChatRooms

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Create a new ChatRoom.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="chatroom-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Create ChatRoom</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{chat_room: chat_room} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(ChatRooms.change_chat_room(chat_room))
     end)}
  end

  @impl true
  def handle_event("validate", %{"chat_room" => chatroom_params}, socket) do
    changeset = ChatRooms.change_chat_room(socket.assigns.chat_room, chatroom_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"chat_room" => chatroom_params}, socket) do
    case ChatRooms.create_chat_room(chatroom_params) do
      {:ok, _chatroom} ->
        {:noreply,
         socket
         |> put_flash(:info, "ChatRoom created successfully")
         |> push_navigate(to: ~p"/chat_room")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
