defmodule PhxChatRoomWeb.PageControllerTest do
  use PhxChatRoomWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")

    # We'll just check that it is redirected to chat_room
    assert redirected_to(conn) == "/chat_room"
  end
end
