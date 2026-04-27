defmodule AtsWeb.CandidateControllerTest do
  use AtsWeb.ConnCase

  import Ats.CandidatesFixtures

  @create_attrs %{
    email: "some email",
    full_name: "some full_name",
    last_known_job: "some last_known_job",
    phone: "some phone"
  }
  @update_attrs %{
    email: "some updated email",
    full_name: "some updated full_name",
    last_known_job: "some updated last_known_job",
    phone: "some updated phone"
  }
  @invalid_attrs %{email: nil, full_name: nil, last_known_job: nil, phone: nil}

  setup :register_and_log_in_user

  describe "index" do
    test "lists all candidates", %{conn: conn} do
      conn = get(conn, ~p"/candidates")
      assert html_response(conn, 200) =~ "Listing Candidates"
    end
  end

  describe "new candidate" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/candidates/new")
      assert html_response(conn, 200) =~ "New Candidate"
    end
  end

  describe "create candidate" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/candidates", candidate: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/candidates/#{id}"

      conn = get(conn, ~p"/candidates/#{id}")
      assert html_response(conn, 200) =~ "Candidate #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/candidates", candidate: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Candidate"
    end
  end

  describe "edit candidate" do
    setup [:create_candidate]

    test "renders form for editing chosen candidate", %{conn: conn, candidate: candidate} do
      conn = get(conn, ~p"/candidates/#{candidate}/edit")
      assert html_response(conn, 200) =~ "Edit Candidate"
    end
  end

  describe "update candidate" do
    setup [:create_candidate]

    test "redirects when data is valid", %{conn: conn, candidate: candidate} do
      conn = put(conn, ~p"/candidates/#{candidate}", candidate: @update_attrs)
      assert redirected_to(conn) == ~p"/candidates/#{candidate}"

      conn = get(conn, ~p"/candidates/#{candidate}")
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn, candidate: candidate} do
      conn = put(conn, ~p"/candidates/#{candidate}", candidate: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Candidate"
    end
  end

  describe "delete candidate" do
    setup [:create_candidate]

    test "deletes chosen candidate", %{conn: conn, candidate: candidate} do
      conn = delete(conn, ~p"/candidates/#{candidate}")
      assert redirected_to(conn) == ~p"/candidates"

      assert_error_sent 404, fn ->
        get(conn, ~p"/candidates/#{candidate}")
      end
    end
  end

  defp create_candidate(_) do
    candidate = candidate_fixture()
    %{candidate: candidate}
  end
end
