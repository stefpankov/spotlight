defmodule SpotlightWeb.MovieLive.Show do
  use SpotlightWeb, :live_view

  alias Spotlight.Movies

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:movie, Movies.get_movie!(socket.assigns.current_user, id))}
  end

  defp page_title(:show), do: "Show Movie"
  defp page_title(:edit), do: "Edit Movie"
end
