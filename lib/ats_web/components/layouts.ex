defmodule AtsWeb.Layouts do
  @moduledoc """
  This module provides functions for rendering layouts.
  """
  use AtsWeb, :html

  embed_templates "layouts/*"
end
