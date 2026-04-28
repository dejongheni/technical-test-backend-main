defmodule Ats.Applicants.ApplicationNotifier do
  @moduledoc """
  This module provides functions for sending emails to users on application creation.
  """
  import Swoosh.Email
  import Phoenix.Component

  alias Ats.Mailer

  use Phoenix.VerifiedRoutes,
    endpoint: AtsWeb.Endpoint,
    router: AtsWeb.Router,
    statics: AtsWeb.static_paths()

  def deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Ats", Application.get_env(:ats, :sender_email)})
      |> subject(subject)
      |> html_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Sends an email notification to the user when a new application is created for their job posting.

  Sends the email asynchronously using a Task.Supervisor to avoid blocking the main application flow.

  Retrys up to 5 times in case of failure.

  ## Examples

      iex> deliver_application_notification(applicant)
      {:ok, <pid>}

  """
  def deliver_application_notification(applicant) do
    applicant = Ats.Repo.preload(applicant, job: :user)
    if !is_nil(applicant.job.user) and !is_nil(applicant.job.user.email) do
      mail_to = applicant.job.user.email
      job = applicant.job
      url = AtsWeb.Endpoint.url() <> ~p"/jobs/#{job.id}"

      body = deliver_notification_email_content(%{mail_to: mail_to, job_title: job.title, url: url})
        |> Phoenix.HTML.html_escape()
        |> Phoenix.HTML.safe_to_string()

      Task.Supervisor.start_child(
        Ats.MailerTaskSupervisor,
        __MODULE__,
        :deliver,
        [mail_to, "Application Notification", body],
        restart: :transient,
        max_restarts: 5
      )
    end
  end

  def deliver_notification_email_content(assigns) do
    ~H"""
      <html>
        <body>
        <p>Hello <%= @mail_to %>,</p>

        <p>A new candidate has applied for your job posting "<%= @job_title %>".</p>

        <p>You can view the application by visiting the URL below:</p>
        <a href={@url}><%= @url %></a>
        </body>
      </html>
    """
  end
end
