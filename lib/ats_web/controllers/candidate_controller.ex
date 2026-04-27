defmodule AtsWeb.CandidateController do
  use AtsWeb, :controller

  alias Ats.Candidates
  alias Ats.Candidates.Candidate

  def index(conn, _params) do
    candidates = Candidates.list_candidates()
    render(conn, :index, candidates: candidates)
  end

  def new(conn, _params) do
    changeset = Candidates.change_candidate(%Candidate{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"candidate" => candidate_params}) do
    case Candidates.create_candidate(candidate_params) do
      {:ok, candidate} ->
        conn
        |> put_flash(:info, "Candidate created successfully.")
        |> redirect(to: ~p"/candidates/#{candidate}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    candidate = Candidates.get_candidate!(id)
    render(conn, :show, candidate: candidate)
  end

  def edit(conn, %{"id" => id}) do
    candidate = Candidates.get_candidate!(id)
    changeset = Candidates.change_candidate(candidate)
    render(conn, :edit, candidate: candidate, changeset: changeset)
  end

  def update(conn, %{"id" => id, "candidate" => candidate_params}) do
    candidate = Candidates.get_candidate!(id)

    case Candidates.update_candidate(candidate, candidate_params) do
      {:ok, candidate} ->
        conn
        |> put_flash(:info, "Candidate updated successfully.")
        |> redirect(to: ~p"/candidates/#{candidate}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, candidate: candidate, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    candidate = Candidates.get_candidate!(id)
    {:ok, _candidate} = Candidates.delete_candidate(candidate)

    conn
    |> put_flash(:info, "Candidate deleted successfully.")
    |> redirect(to: ~p"/candidates")
  end
end
