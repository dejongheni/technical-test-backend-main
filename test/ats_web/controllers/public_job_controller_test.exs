defmodule AtsWeb.PublicJobControllerTest do
  use AtsWeb.ConnCase

  describe "index" do
    test "lists all published jobs", %{conn: conn} do
      conn = get(conn, ~p"/")
      assert html_response(conn, 200) =~ "Listing Jobs"
    end
  end
end
