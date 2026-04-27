defmodule AtsWeb.ProfessionHTML do
  use AtsWeb, :html

  embed_templates "profession_html/*"

  @doc """
  Renders a profession form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def profession_form(assigns)
end
