defmodule PhxTalkWeb.ChatRoomLive.FormComponent do
  use PhxTalkWeb, :live_component

  alias PhxTalk.ChatRooms

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
      </.header>

      <.simple_form
        for={@form}
        id="chatroom-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit={
          if @id == :new do
            "save"
          else
            "edit"
          end
        }
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">
            {if @id == :new do
              "Create"
            else
              "Save"
            end}
          </.button>
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
  def handle_event(
        "validate",
        %{"chat_room" => chatroom_params},
        %{assigns: %{chat_room: chat_room}} = socket
      ) do
    changeset = ChatRooms.change_chat_room(chat_room, chatroom_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event(
        "save",
        %{"chat_room" => chatroom_params},
        %{assigns: %{current_user: current_user}} = socket
      ) do
    chatroom_params = Map.put(chatroom_params, "user_id", current_user.id)

    case ChatRooms.create_chat_room(chatroom_params) do
      {:ok, chatroom} ->
        PhxTalkWeb.Endpoint.broadcast("chat_room", "new_chatroom", chatroom)

        {:noreply,
         socket
         |> put_flash(:info, "ChatRoom created successfully")
         |> push_patch(to: ~p"/chat_room")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("edit", %{"chat_room" => chatroom_params}, socket) do
    chat_room = ChatRooms.get_chat_room!(socket.assigns.chat_room.id)

    case ChatRooms.update_chat_room(chat_room, chatroom_params) do
      {:ok, chatroom} ->
        PhxTalkWeb.Endpoint.broadcast("chat_room", "edit_chatroom", chatroom)

        {:noreply,
         socket
         |> put_flash(:info, "ChatRoom edited successfully")
         |> push_patch(to: ~p"/chat_room")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
