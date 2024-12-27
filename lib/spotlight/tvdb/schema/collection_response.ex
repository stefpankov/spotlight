defmodule Spotlight.TVDB.CollectionResponse do
  defstruct [:data, :status, :links]
  @type t :: %__MODULE__{
    data: list(),
    status: String.t(),
    links: %{
      prev: String.t(),
      self: String.t(),
      next: String.t(),
      total_items: integer(),
      page_size: integer()
    }
  }
end
