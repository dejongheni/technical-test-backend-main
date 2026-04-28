defmodule Ats.Applicants.ApplicationNotifierTest do
  use ExUnit.Case, async: false

  import Swoosh.TestAssertions
  import Ats.JobsFixtures
  import Ats.AccountsFixtures
  import Ats.ApplicantsFixtures

  alias Ats.Applicants.ApplicationNotifier


  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Ats.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Ats.Repo, {:shared, self()})
    :ok
  end

  describe "deliver_application_notification/1" do
    test "sends an email notification" do
      user = user_fixture()
      job = job_fixture(user_id: user.id)
      applicant = applicant_fixture(job_id: job.id)

      ApplicationNotifier.deliver_application_notification(applicant)

      Process.sleep(100)

      assert_email_sent(
        subject: "Application Notification",
        to: [{"", user.email}]
      )
    end
  end
end
