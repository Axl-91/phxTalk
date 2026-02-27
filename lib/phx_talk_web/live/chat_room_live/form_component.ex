defmodule PhxTalkWeb.ChatRoomLive.FormComponent do
  use PhxTalkWeb, :live_component

  alias PhxTalk.ChatRooms
  alias PhxTalk.Accounts

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
        <.input field={@form[:private]} type="checkbox" label="Private" />
        <.input
          field={@form[:emails]}
          type="select"
          options={get_email_options(@current_user.email)}
          label="Select Users"
          hidden={@form[:private].value}
          multiple
        />
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
    emails = get_emails(assigns[:id], chat_room.users)

    form_params = %{
      "name" => chat_room.name,
      "description" => chat_room.description,
      "private" => chat_room.private,
      "emails" => emails
    }

    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(form_params, as: :chat_room)
     end)}
  end

  @impl true
  def handle_event(
        "validate",
        %{"chat_room" => chatroom_params},
        socket
      ) do
    form_params = %{
      "name" => chatroom_params["name"],
      "description" => chatroom_params["description"],
      "private" => chatroom_params["private"],
      "emails" => chatroom_params["emails"]
    }

    errors = errors_from_chatroom_params(form_params)

    socket =
      socket
      |> assign(form: to_form(form_params, as: :chat_room, errors: errors, action: :validate))

    {:noreply, socket}
  end

  def handle_event(
        "save",
        %{"chat_room" => chatroom_params},
        %{assigns: %{current_user: current_user}} = socket
      ) do
    users = get_users(chatroom_params["emails"], current_user)

    chatroom_params =
      chatroom_params
      |> Map.put("user_id", current_user.id)
      |> Map.put("users", users)

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

  def handle_event(
        "edit",
        %{"chat_room" => chatroom_params},
        %{assigns: %{current_user: current_user}} = socket
      ) do
    users = get_users(chatroom_params["emails"], current_user)

    chatroom_params =
      chatroom_params
      |> Map.put("users", users)

    case ChatRooms.update_chat_room(socket.assigns.chat_room, chatroom_params) do
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

  defp get_email_options(creator_email),
    do: Enum.reject(Accounts.list_users(), fn email -> email == creator_email end)

  defp get_emails(:new, _), do: []
  defp get_emails(_, users), do: Enum.map(users, fn u -> u.email end)

  defp get_users(nil, _), do: []

  defp get_users(emails, current_user) do
    [current_user | Enum.map(emails, fn e -> Accounts.get_user_by_email(e) end)]
  end

  defp errors_from_chatroom_params(chatroom_params) do
    chatroom_params
    |> Enum.reject(fn {key, _} -> key == "emails" end)
    |> Enum.reduce([], fn {key, value}, acc ->
      case {key, String.trim(value)} do
        {"name", ""} -> [{:name, {"can't be blank", []}} | acc]
        {"description", ""} -> [{:description, {"can't be blank", []}} | acc]
        _ -> acc
      end
    end)
  end
end
