defmodule SpotlightWeb.MovieLive.Index do
  use SpotlightWeb, :live_view

  alias Spotlight.Movies
  alias Spotlight.Movies.Movie

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :movies, Movies.list_movies(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Movie")
    |> assign(:movie, Movies.get_movie!(socket.assigns.current_user, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Movie")
    |> assign(:movie, %Movie{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Movies")
    |> assign(:movie, nil)
  end

  @impl true
  def handle_info({SpotlightWeb.MovieLive.FormComponent, {:saved, movie}}, socket) do
    {:noreply, stream_insert(socket, :movies, movie)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    movie = Movies.get_movie!(socket.assigns.current_user, id)
    {:ok, _} = Movies.delete_movie(movie)

    {:noreply, stream_delete(socket, :movies, movie)}
  end
end
