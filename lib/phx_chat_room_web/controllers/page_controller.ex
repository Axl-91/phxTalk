defmodule PhxChatRoomWeb.PageController do
  use PhxChatRoomWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    redirect(conn, to: ~p"/chat_room")
  end
end
