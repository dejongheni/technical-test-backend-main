defmodule AtsWeb.JobHTML do
  use AtsWeb, :html

  embed_templates "job_html/*"

  @doc """
  Renders a job form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def job_form(assigns)

  attr :name, :string, required: true
  attr :age, :integer, required: true
  def greet(assigns) do
    ~H"""
    <p>Hello, <%= @name %> - <%= @age %> !</p>
    """
  end

  slot :header, required: true
  slot :inner_block, required: true
  slot :footer, required: true

  def hif_block(assigns) do
    ~H"""
    <p><%= render_slot(@header) %></p>
    <p><%= render_slot(@inner_block) %></p>
    <p><%= render_slot(@footer) %></p>
    """
  end

  attr :rows, :list, required: true
  slot :column, doc: "Columns with column labels" do
    attr :label, :string, required: true, doc: "Column label"
  end

  def jobs_table(assigns) do
    ~H"""
    <table>
      <tr>
        <%= for col <- @column do %>
          <th><%= col.label %></th>
        <% end %>
      </tr>
      <%= for row <- @rows do %>
        <tr>
          <%= for col <- @column do %>
            <td><%= render_slot(col, row) %></td>
          <% end %>
        </tr>
      <% end %>
    </table>
    """
  end

  attr :value, :string, required: true

  def badge(assigns) do
    ~H"""
    <span class="inline-flex items-center rounded-md bg-yellow-50 px-2 py-1 text-xs font-medium text-yellow-800 ring-1 ring-inset ring-yellow-600/20"><%= @value %></span>
    """
  end
end
