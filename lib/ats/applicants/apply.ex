defmodule Ats.Applicants.Apply do
  @moduledoc """
  This module provides functions for managing applications.
  """
  use Ecto.Schema
  import Ecto.Changeset

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
  end

  def to_candidate(%Ecto.Changeset{changes: changes}) do
    Ats.Candidates.Candidate.changeset(
      %Ats.Candidates.Candidate{},
      %{
        full_name: changes.full_name,
        email: changes.email,
        phone: changes.phone,
        last_known_job: changes.last_known_job
      }
    )
  end

  def to_applicant(%Ecto.Changeset{changes: changes}) do
    Ats.Applicants.Applicant.changeset(%Ats.Applicants.Applicant{}, %{
      application_date: Date.utc_today(),
      status: "new",
      salary_expectation: changes.salary_expectation,
      job_id: changes.job_id
      # candidate_id: changes.candidate_id
    })
  end
end
