defmodule AtsWeb.ProfessionControllerTest do
  use AtsWeb.ConnCase

  import Ats.ProfessionsFixtures

  @create_attrs %{category_name: "some category_name", name: "some name"}
  @update_attrs %{category_name: "some updated category_name", name: "some updated name"}
  @invalid_attrs %{category_name: nil, name: nil}

  setup :register_and_log_in_user

  describe "index" do
    test "lists all professions", %{conn: conn} do
      conn = get(conn, ~p"/professions")
      assert html_response(conn, 200) =~ "Listing Professions"
    end
  end

  describe "new profession" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/professions/new")
      assert html_response(conn, 200) =~ "New Profession"
    end
  end

  describe "create profession" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/professions", profession: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/professions/#{id}"

      conn = get(conn, ~p"/professions/#{id}")
      assert html_response(conn, 200) =~ "Profession #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/professions", profession: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Profession"
    end
  end

  describe "edit profession" do
    setup [:create_profession]

    test "renders form for editing chosen profession", %{conn: conn, profession: profession} do
      conn = get(conn, ~p"/professions/#{profession}/edit")
      assert html_response(conn, 200) =~ "Edit Profession"
    end
  end

  describe "update profession" do
    setup [:create_profession]

    test "redirects when data is valid", %{conn: conn, profession: profession} do
      conn = put(conn, ~p"/professions/#{profession}", profession: @update_attrs)
      assert redirected_to(conn) == ~p"/professions/#{profession}"

      conn = get(conn, ~p"/professions/#{profession}")
      assert html_response(conn, 200) =~ "some updated category_name"
    end

    test "renders errors when data is invalid", %{conn: conn, profession: profession} do
      conn = put(conn, ~p"/professions/#{profession}", profession: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Profession"
    end
  end

  describe "delete profession" do
    setup [:create_profession]

    test "deletes chosen profession", %{conn: conn, profession: profession} do
      conn = delete(conn, ~p"/professions/#{profession}")
      assert redirected_to(conn) == ~p"/professions"

      assert_error_sent 404, fn ->
        get(conn, ~p"/professions/#{profession}")
      end
    end
  end

  defp create_profession(_) do
    profession = profession_fixture()
    %{profession: profession}
  end
end
