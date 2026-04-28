defmodule Ats.ApplicantsTest do
  use Ats.DataCase

  import Swoosh.TestAssertions
  import Ats.JobsFixtures
  import Ats.AccountsFixtures
  import Ats.ApplicantsFixtures

  alias Ats.Applicants

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Ats.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Ats.Repo, {:shared, self()})
    :ok
  end

  describe "applicants" do
    alias Ats.Applicants.Applicant

    import Ats.ApplicantsFixtures

    @invalid_attrs %{application_date: nil, salary_expectation: nil, status: nil}

    test "list_applicants/0 returns all applicants" do
      applicant = applicant_fixture()
      assert Applicants.list_applicants() == [applicant]
    end

    test "get_applicant!/1 returns the applicant with given id" do
      applicant = applicant_fixture()
      assert Applicants.get_applicant!(applicant.id) == applicant
    end

    test "create_applicant/1 with valid data creates a applicant" do
      valid_attrs = %{application_date: ~D[2023-06-03], salary_expectation: 42, status: "some status"}

      assert {:ok, %Applicant{} = applicant} = Applicants.create_applicant(valid_attrs)
      assert applicant.application_date == ~D[2023-06-03]
      assert applicant.salary_expectation == 42
      assert applicant.status == "some status"
    end

    test "create_applicant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applicants.create_applicant(@invalid_attrs)
    end

    test "update_applicant/2 with valid data updates the applicant" do
      applicant = applicant_fixture()
      update_attrs = %{application_date: ~D[2023-06-04], salary_expectation: 43, status: "some updated status"}

      assert {:ok, %Applicant{} = applicant} = Applicants.update_applicant(applicant, update_attrs)
      assert applicant.application_date == ~D[2023-06-04]
      assert applicant.salary_expectation == 43
      assert applicant.status == "some updated status"
    end

    test "update_applicant/2 with invalid data returns error changeset" do
      applicant = applicant_fixture()
      assert {:error, %Ecto.Changeset{}} = Applicants.update_applicant(applicant, @invalid_attrs)
      assert applicant == Applicants.get_applicant!(applicant.id)
    end

    test "delete_applicant/1 deletes the applicant" do
      applicant = applicant_fixture()
      assert {:ok, %Applicant{}} = Applicants.delete_applicant(applicant)
      assert_raise Ecto.NoResultsError, fn -> Applicants.get_applicant!(applicant.id) end
    end

    test "change_applicant/1 returns a applicant changeset" do
      applicant = applicant_fixture()
      assert %Ecto.Changeset{} = Applicants.change_applicant(applicant)
    end
  end

  describe "create_apply/1" do
    import Ats.JobsFixtures
    import Ats.AccountsFixtures

    test "with valid data creates an application and a candidate" do
      user = user_fixture()
      job = job_fixture(user_id: user.id)
      attrs = %{
        "job_id" => "#{job.id}",
        "full_name" => "Test candidate",
        "email" => "test@test.com",
        "phone" => "1234567890",
        "last_known_job" => "Developer",
        "salary_expectation" => "50000"
      }

      assert {:ok, %{candidate: candidate, applicant: applicant}} = Applicants.create_apply(attrs)
      assert candidate.email == "test@test.com"
      assert applicant.job_id == job.id

      Process.sleep(100)
      assert_email_sent(
        subject: "Application Notification",
        to: [{"", user.email}]
      )
    end

    test "duplicate candidate is rejected" do
      user = user_fixture()
      job = job_fixture(user_id: user.id)
      attrs = %{
        "job_id" => "#{job.id}",
        "full_name" => "Test candidate",
        "email" => "test@test.com",
        "phone" => "1234567890",
        "last_known_job" => "Developer",
        "salary_expectation" => "50000"
      }

      assert {:ok, %{candidate: candidate, applicant: applicant}} = Applicants.create_apply(attrs)
      assert candidate.email == "test@test.com"
      assert applicant.job_id == job.id

      assert {:error, %Ecto.Changeset{
        errors: [
          phone: {"Candidate with this email or phone number has already applied for this job", []},
          email: {"Candidate with this email or phone number has already applied for this job", []}
        ]
      }} = Applicants.create_apply(attrs)
    end
  end
end
