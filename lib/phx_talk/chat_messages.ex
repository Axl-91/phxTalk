defmodule PhxTalk.ChatMessages do
  @moduledoc """
  The ChatMessages context.
  """

  import Ecto.Query, warn: false
  alias PhxTalk.ChatRooms.ChatRoom
  alias PhxTalk.Accounts.User
  alias PhxTalk.Repo

  alias PhxTalk.ChatMessages.ChatMessage

  @doc """
  Returns the list of chat_messages.

  ## Examples

      iex> list_chat_messages()
      [%ChatMessage{}, ...]

  """
  def list_chat_messages do
    Repo.all(from m in ChatMessage, order_by: [asc: m.inserted_at])
  end

  @doc """
  Returns the list of chat_messages that
  belong to the chat_room given.

  ## Examples

      iex> list_chat_messages_by_chat_room(chat_room)
      [%ChatMessage{}, ...]

  """
  def list_chat_messages_by_chat_room(chat_room_id) do
    q =
      from cm in ChatMessage,
        where: cm.chat_room_id == ^chat_room_id,
        order_by: [desc: cm.inserted_at],
        preload: :user,
        limit: 25

    Repo.all(q) |> Enum.sort_by(fn cm -> cm.inserted_at end)
  end

  @doc """
  Gets a single chat_message.

  Raises `Ecto.NoResultsError` if the Chat message does not exist.

  ## Examples

      iex> get_chat_message!(123)
      %ChatMessage{}

      iex> get_chat_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat_message!(id), do: Repo.get!(ChatMessage, id)

  @doc """
  Creates a chat_message.

  ## Examples

      iex> create_chat_message(%User{}, %ChatRoom}{}, %{field: value})
      {:ok, %ChatMessage{}}

      iex> create_chat_message(%User{}, %ChatRoom}{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat_message(%User{id: user_id}, %ChatRoom{id: chat_room_id}, attrs \\ %{}) do
    attrs =
      Map.merge(attrs, %{"user_id" => user_id, "chat_room_id" => chat_room_id})

    %ChatMessage{}
    |> ChatMessage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chat_message.

  ## Examples

      iex> update_chat_message(chat_message, %{field: new_value})
      {:ok, %ChatMessage{}}

      iex> update_chat_message(chat_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat_message(%ChatMessage{} = chat_message, attrs) do
    chat_message
    |> ChatMessage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a chat_message.

  ## Examples

      iex> delete_chat_message(chat_message)
      {:ok, %ChatMessage{}}

      iex> delete_chat_message(chat_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat_message(%ChatMessage{} = chat_message) do
    Repo.delete(chat_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chat_message changes.

  ## Examples

      iex> change_chat_message(chat_message)
      %Ecto.Changeset{data: %ChatMessage{}}

  """
  def change_chat_message(%ChatMessage{} = chat_message, attrs \\ %{}) do
    ChatMessage.changeset(chat_message, attrs)
  end
end
