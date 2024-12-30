defmodule SpotlightWeb.ExploreSearchLive do
  use SpotlightWeb, :live_view

  require Logger
  alias Spotlight.Movies
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
          <.input
            field={@search_form[:type]}
            type="select"
            label="Type"
            required
            options={[Movie: "movie", Series: "series"]}
          />
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
          <%= if Map.has_key?(@annotated, result.id) do %>
            <p class="pointer-events-none block text-sm font-medium text-gray-500">
              Watched!
            </p>
          <% else %>
            <.button type="button" phx-click={JS.push("track_movie", value: %{movie: result})}>
              Mark as watched!
            </.button>
          <% end %>
        </li>
      </ul>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    data = %{query: ""}
    types = %{query: :string}
    search_form = Changeset.change({data, types})

    {:ok, assign(socket, search_results: [], annotated: %{}, search_form: to_form(search_form, as: :search_form))}
  end

  def handle_event("search", %{"search_form" => params}, socket) do
    %{"query" => query, "type" => type} = params
    user = socket.assigns.current_user

    with {:ok, %{data: data}} <- Search.simple(query, type),
      annotated <- Movies.annotated_tracked(user, Enum.map(data, &(&1.id)))
    do
      IO.inspect(annotated)
      {:noreply, socket |> assign(search_results: data, annotated: annotated)}
    else
      {:error, exception} ->
        Logger.error("Search.simple failed", exception: exception, params: params)

        {:noreply,
         socket
         |> put_flash(:error, "Unexpected error while searching. Please try again a bit later.")}
    end
  end

  def handle_event("track_movie", %{"movie" => movie}, socket) do
    user = socket.assigns.current_user

    payload = %{
      name: movie["name"],
      external_id: movie["id"],
      user_id: user.id,
      image_url: movie["image_url"],
      year: movie["year"]
    }

    case Movies.create_movie(user, payload) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:success, "Movie added to your library.")
         |> push_navigate(to: "/movies")}

      {:error, changeset} ->
        Logger.error("[live:track_movie]", %{errors: changeset.errors})

        {:noreply,
         socket |> put_flash(:error, "Movie cannot be added to your library at this time.")}
    end
  end
end
