defmodule AtsWeb.ApplyHTML do
  use AtsWeb, :html

  embed_templates "apply_html/*"

  @doc """
  Renders a applicant form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def apply_form(assigns)
end
