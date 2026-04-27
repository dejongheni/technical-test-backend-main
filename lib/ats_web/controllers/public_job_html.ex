defmodule AtsWeb.PublicJobHTML do
  use AtsWeb, :html

  embed_templates "public_job_html/*"

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
    <span class="inline-flex items-center rounded-md bg-yellow-50 px-2 py-1 text-xs font-medium text-yellow-800 ring-1 ring-inset ring-yellow-600/20">
      <%= @value %>
    </span>
    """
  end
end
