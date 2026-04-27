defmodule AtsWeb.ApplyControllerTest do
  use AtsWeb.ConnCase
  import Ats.JobsFixtures

  @create_attrs %{
    full_name: "John Doe",
    email: "john.doe@gmail.com",
    last_known_job: "Dev Backend",
    phone: "+336 06 06 06 06",
    salary_expectation: "50000"
  }
  @invalid_attrs %{
    full_name: nil,
    email: nil,
    last_known_job: nil,
    phone: nil,
    salary_expectation: nil
  }

  setup :register_and_log_in_user

  describe "new applicant" do
    test "renders form", %{conn: conn} do
      job = job_fixture()
      conn = get(conn, ~p"/#{job.id}/applies/new")
      assert html_response(conn, 200) =~ "You will be applying for"
    end
  end

  describe "create applicant" do
    test "redirects to show when data is valid", %{conn: conn} do
      job = job_fixture()
      conn = post(conn, ~p"/#{job.id}/applies", apply: @create_attrs)

      assert redirected_to(conn) == ~p"/"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      job = job_fixture()
      conn = post(conn, ~p"/#{job.id}/applies", apply: @invalid_attrs)
      assert html_response(conn, 200) =~ "You will be applying for the position of"
    end
  end
end
