defmodule Ats.Repo.Migrations.UpdateOnDeleteApplicants do
  use Ecto.Migration

  def up do
    drop constraint(:applicants, "applicants_job_id_fkey")
    alter table(:applicants) do
      modify :job_id, references(:jobs, on_delete: :delete_all)
    end
  end

  def down do
    drop constraint(:applicants, "applicants_job_id_fkey")
    alter table(:applicants) do
      modify :job_id, references(:jobs, on_delete: :nothing)
    end
  end
end
