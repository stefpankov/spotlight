defmodule SpotlightWeb.MovieHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `movie_html` directory for all templates available.
  """
  use SpotlightWeb, :html

  embed_templates "movie_html/*"
end
