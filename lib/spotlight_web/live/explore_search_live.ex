defmodule SpotlightWeb.ExploreSearchLive do
  use SpotlightWeb, :live_view

  require Logger
  alias Spotlight.Search
  alias Ecto.Changeset

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Explore
      <:subtitle>Search for TV series or Movies</:subtitle>
    </.header>

    <div class="space-y-12 divide-y">
      <div>
        <.simple_form for={@search_form} id="search_form" phx-submit="search">
          <.input field={@search_form[:query]} type="text" label="Query" required />
          <.input field={@search_form[:type]} type="select" label="Type" required options={["Movie": "movie", "Series": "series"]} />
          <:actions>
            <.button phx-disable-with="Searching...">Search</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>

    <div class="mt-4">
      <%= if length(@search_results) == 0 do %>
        <p>No results...</p>
      <% end %>
      <ul
        role="list"
        class="grid grid-cols-2 gap-x-4 gap-y-8 sm:grid-cols-3 sm:gap-x-6 lg:grid-cols-4 xl:gap-x-8"
      >
        <li :for={result <- @search_results} class="relative">
          <div class="group overflow-hidden rounded-lg bg-gray-100 focus-within:ring-2 focus-within:ring-indigo-500 focus-within:ring-offset-2 focus-within:ring-offset-gray-100">
            <img
              src={result.image_url}
              alt={result.name}
              class="pointer-events-none object-cover group-hover:opacity-75"
            />
          </div>
          <p class="pointer-events-none mt-2 block truncate text-sm font-medium text-gray-900">
            {result.name}
          </p>
          <p class="pointer-events-none block text-sm font-medium text-gray-500">{result.year}</p>
          <p class="pointer-events-none block text-sm font-medium text-gray-500">{result.type}</p>
        </li>
      </ul>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    data = %{query: ""}
    types = %{query: :string}
    search_form = Changeset.change({data, types})

    {:ok, assign(socket, search_results: [], search_form: to_form(search_form, as: :search_form))}
  end

  def handle_event("search", %{"search_form" => params}, socket) do
    %{"query" => query, "type" => type} = params

    case Search.simple(query, type) do
      {:ok, %{data: data}} ->
        {:noreply, socket |> assign(search_results: data)}

      {:error, exception} ->
        Logger.error("Search.simple failed", [exception: exception, params: params])
        {:noreply, socket |> put_flash(:error, "Unexpected error while searching. Please try again a bit later.")}
    end
  end
end
