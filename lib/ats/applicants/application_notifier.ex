defmodule Ats.Applicants.ApplicationNotifier do
  @moduledoc """
  This module provides functions for sending emails to users on application creation.
  """
  import Swoosh.Email

  alias Ats.Mailer

  use Phoenix.VerifiedRoutes,
    endpoint: AtsWeb.Endpoint,
    router: AtsWeb.Router,
    statics: AtsWeb.static_paths()

  def deliver(recipient, subject, text_body, html_body) do
    email =
      new()
      |> to(recipient)
      |> from({"Ats", Application.get_env(:ats, :sender_email)})
      |> subject(subject)
      |> text_body(text_body)
      |> html_body(html_body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  def deliver_application_notification(applicant) do
    applicant = Ats.Repo.preload(applicant, job: :user)
    if !is_nil(applicant.job.user) and !is_nil(applicant.job.user.email) do
      mail_to = applicant.job.user.email
      job = applicant.job
      url = AtsWeb.Endpoint.url() <> ~p"/jobs/#{job.id}"

      Task.start(__MODULE__, :deliver, [
        mail_to,
        "Application Notification",
        """
        Hello #{mail_to},

        A new candidate has applied for your job posting "#{job.title}".

        You can view the application by visiting the URL below:
        #{url}
        """,
        """
        <html>
        <body>
        <p>Hello #{mail_to},</p>

        <p>A new candidate has applied for your job posting "#{job.title}".</p>

        <p>You can view the application by visiting the URL below:</p>
        <a href="#{url}">#{url}</a>
        </body>
        </html>
        """
      ])
    end
  end
end
