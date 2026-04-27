defmodule AtsWeb.ApplyController do
  use AtsWeb, :controller

  alias Ats.Applicants
  alias Ats.Applicants.Apply
  alias Ats.Jobs

  def new(conn, params) do
    job = Jobs.get_job!(params["job_id"])
    changeset = Apply.changeset(%Apply{}, %{job_id: job.id})
    render(conn, :new, changeset: changeset, job: job)
  end

  def create(conn, %{"apply" => param, "job_id" => job_id}) do
    job = Jobs.get_job!(job_id)

    case Applicants.create_apply(Map.merge(param, %{"job_id" => job_id})) do
      {:ok, _apply} ->
        conn
        |> put_flash(:info, "Applicant created successfully.")
        |> redirect(to: ~p"/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset, job: job)
    end
  end
end
