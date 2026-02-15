defmodule PhxChatRoomWeb.ChatMessageLive.FormComponent do
  use PhxChatRoomWeb, :live_component

  alias PhxChatRoom.ChatMessages

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} id="message-form" phx-target={@myself} phx-submit="save">
        <.input
          id="input-chat"
          field={@form[:message]}
          type="text"
          value=""
          placeholder="Write a message..."
          phx-change="validate"
          phx-hook="updateText"
        />
        <:actions>
          <.button phx-disable-with="Saving...">Send</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(ChatMessages.change_chat_message(%ChatMessages.ChatMessage{}))
     end)}
  end

  @impl true
  def handle_event("validate", %{"chat_message" => message_params}, socket) do
    changeset =
      ChatMessages.change_chat_message(%ChatMessages.ChatMessage{}, message_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  @impl true
  def handle_event("save", %{"chat_message" => message_params}, socket) do
    user = socket.assigns.current_user
    chat_room = socket.assigns.active_chat_room

    case ChatMessages.create_chat_message(user, chat_room, message_params) do
      {:ok, message} ->
        message = message |> PhxChatRoom.Repo.preload(:user)

        socket =
          socket
          |> push_event("clear-text", %{})

        PhxChatRoomWeb.Endpoint.broadcast("chat_room", "new_message", message)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
