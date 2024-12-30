defmodule SpotlightWeb.MovieLiveTest do
  use SpotlightWeb.ConnCase

  import Phoenix.LiveViewTest
  import Spotlight.MoviesFixtures
  import Spotlight.AccountsFixtures

  @create_attrs %{
    name: "some name",
    external_id: "some external_id",
    image_url: "some image_url",
    rating: 6,
    year: "2006"
  }
  @update_attrs %{
    name: "some updated name",
    external_id: "some updated external_id",
    image_url: "some updated image_url",
    rating: 7,
    year: "2005"
  }
  @invalid_attrs %{name: nil, external_id: nil, image_url: nil, rating: nil, year: nil}

  defp create_movie(_) do
    user = user_fixture()
    movie = movie_fixture(user)
    %{user: user, movie: movie}
  end

  describe "Index" do
    setup [:create_movie]

    test "lists all movies", %{conn: conn, user: user, movie: movie} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/movies")

      assert html =~ "Listing Movies"
      assert html =~ movie.name
    end

    test "saves new movie", %{conn: conn} do
      user = user_fixture()

      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/movies/new")

      assert index_live
             |> form("#movie-form", movie: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#movie-form", movie: @create_attrs)
             |> render_submit()
    end

    test "updates movie in listing", %{conn: conn, user: user, movie: movie} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/movies")

      assert index_live |> element("#movies-#{movie.id} a", "Edit") |> render_click() =~
               "Edit Movie"

      assert_patch(index_live, ~p"/movies/#{movie}/edit")

      assert index_live
             |> form("#movie-form", movie: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#movie-form", movie: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/movies")

      html = render(index_live)
      assert html =~ "Movie updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes movie in listing", %{conn: conn, user: user, movie: movie} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/movies")

      assert index_live |> element("#movies-#{movie.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#movies-#{movie.id}")
    end
  end

  describe "Show" do
    setup [:create_movie]

    test "displays movie", %{conn: conn, user: user, movie: movie} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/movies/#{movie}")

      assert html =~ "Show Movie"
      assert html =~ movie.name
    end

    test "updates movie within modal", %{conn: conn, user: user, movie: movie} do
      {:ok, show_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/movies/#{movie}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Movie"

      assert_patch(show_live, ~p"/movies/#{movie}/show/edit")

      assert show_live
             |> form("#movie-form", movie: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#movie-form", movie: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/movies/#{movie}")

      html = render(show_live)
      assert html =~ "Movie updated successfully"
      assert html =~ "some updated name"
    end
  end
end
