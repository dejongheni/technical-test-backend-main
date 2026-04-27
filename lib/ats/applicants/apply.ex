defmodule Ats.Applicants.Apply do
  @moduledoc """
  This module provides functions for managing applications.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Ats.Candidates.Candidate
  alias Ats.Applicants.Applicant

  embedded_schema do
    field :email, :string
    field :full_name, :string
    field :last_known_job, :string
    field :phone, :string
    field :salary_expectation, :integer
    field :job_id, :integer
  end

  def changeset(apply, attrs) do
    apply
    |> cast(attrs, [:full_name, :email, :phone, :last_known_job, :salary_expectation, :job_id])
    |> validate_required([
      :full_name,
      :email,
      :phone,
      :last_known_job,
      :salary_expectation,
      :job_id
    ])
    |> validate_unique_candidate_for_job()
  end

  defp validate_unique_candidate_for_job(changeset) do
    email = get_field(changeset, :email)
    phone = get_field(changeset, :phone)
    job_id = get_field(changeset, :job_id)

    if is_nil(email) or is_nil(phone) or is_nil(job_id) do
      changeset
    else
      candidates_already_applied? =
        Ats.Repo.exists?(
          from a in Applicant,
          join: c in Candidate, on: c.id == a.candidate_id,
          where: (c.email == ^email or c.phone == ^phone) and a.job_id == ^job_id
        )

      if candidates_already_applied? do
        add_error(changeset, :email, "Candidate with this email or phone number has already applied for this job")
        |> add_error(:phone, "Candidate with this email or phone number has already applied for this job")
      else
        changeset
      end
    end
  end

  def to_candidate(%Ecto.Changeset{changes: changes}) do
    Candidate.changeset(
      %Candidate{},
      %{
        full_name: changes.full_name,
        email: changes.email,
        phone: changes.phone,
        last_known_job: changes.last_known_job
      }
    )
  end

  def to_applicant(%Ecto.Changeset{changes: changes}) do
    Applicant.changeset(%Applicant{}, %{
      application_date: Date.utc_today(),
      status: "new",
      salary_expectation: changes.salary_expectation,
      job_id: changes.job_id
      # candidate_id: changes.candidate_id
    })
  end
end
