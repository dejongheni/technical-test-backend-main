defmodule AtsWeb.CandidateHTML do
  use AtsWeb, :html

  embed_templates "candidate_html/*"

  @doc """
  Renders a candidate form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def candidate_form(assigns)
end
