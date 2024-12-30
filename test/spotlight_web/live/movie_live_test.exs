defmodule SpotlightWeb.MovieLiveTest do
  use SpotlightWeb.ConnCase

  import Phoenix.LiveViewTest
  import Spotlight.MoviesFixtures

  @create_attrs %{name: "some name", external_id: "some external_id", image_url: "some image_url", rating: 42}
  @update_attrs %{name: "some updated name", external_id: "some updated external_id", image_url: "some updated image_url", rating: 43}
  @invalid_attrs %{name: nil, external_id: nil, image_url: nil, rating: nil}

  defp create_movie(_) do
    movie = movie_fixture()
    %{movie: movie}
  end

  describe "Index" do
    setup [:create_movie]

    test "lists all movies", %{conn: conn, movie: movie} do
      {:ok, _index_live, html} = live(conn, ~p"/movies")

      assert html =~ "Listing Movies"
      assert html =~ movie.name
    end

    test "saves new movie", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/movies")

      assert index_live |> element("a", "New Movie") |> render_click() =~
               "New Movie"

      assert_patch(index_live, ~p"/movies/new")

      assert index_live
             |> form("#movie-form", movie: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#movie-form", movie: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/movies")

      html = render(index_live)
      assert html =~ "Movie created successfully"
      assert html =~ "some name"
    end

    test "updates movie in listing", %{conn: conn, movie: movie} do
      {:ok, index_live, _html} = live(conn, ~p"/movies")

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

    test "deletes movie in listing", %{conn: conn, movie: movie} do
      {:ok, index_live, _html} = live(conn, ~p"/movies")

      assert index_live |> element("#movies-#{movie.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#movies-#{movie.id}")
    end
  end

  describe "Show" do
    setup [:create_movie]

    test "displays movie", %{conn: conn, movie: movie} do
      {:ok, _show_live, html} = live(conn, ~p"/movies/#{movie}")

      assert html =~ "Show Movie"
      assert html =~ movie.name
    end

    test "updates movie within modal", %{conn: conn, movie: movie} do
      {:ok, show_live, _html} = live(conn, ~p"/movies/#{movie}")

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
