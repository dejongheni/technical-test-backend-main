defmodule AtsWeb.PublicJobController do
  use AtsWeb, :controller

  alias Ats.Jobs

  def index(conn, _params) do
    jobs = Jobs.list_jobs_with_status("published")
    render(conn, :index, jobs: jobs)
  end
end
