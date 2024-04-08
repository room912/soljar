defmodule SoljarWeb.JarLiveTest do
  use SoljarWeb.ConnCase

  import Phoenix.LiveViewTest
  import Soljar.JarsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_jar(_) do
    jar = jar_fixture()
    %{jar: jar}
  end

  describe "Index" do
    setup [:create_jar]

    test "lists all jars", %{conn: conn, jar: jar} do
      {:ok, _index_live, html} = live(conn, ~p"/jars")

      assert html =~ "Listing Jars"
      assert html =~ jar.name
    end

    test "saves new jar", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/jars")

      assert index_live |> element("a", "New Jar") |> render_click() =~
               "New Jar"

      assert_patch(index_live, ~p"/jars/new")

      assert index_live
             |> form("#jar-form", jar: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#jar-form", jar: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/jars")

      html = render(index_live)
      assert html =~ "Jar created successfully"
      assert html =~ "some name"
    end

    test "updates jar in listing", %{conn: conn, jar: jar} do
      {:ok, index_live, _html} = live(conn, ~p"/jars")

      assert index_live |> element("#jars-#{jar.id} a", "Edit") |> render_click() =~
               "Edit Jar"

      assert_patch(index_live, ~p"/jars/#{jar}/edit")

      assert index_live
             |> form("#jar-form", jar: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#jar-form", jar: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/jars")

      html = render(index_live)
      assert html =~ "Jar updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes jar in listing", %{conn: conn, jar: jar} do
      {:ok, index_live, _html} = live(conn, ~p"/jars")

      assert index_live |> element("#jars-#{jar.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#jars-#{jar.id}")
    end
  end

  describe "Show" do
    setup [:create_jar]

    test "displays jar", %{conn: conn, jar: jar} do
      {:ok, _show_live, html} = live(conn, ~p"/jars/#{jar}")

      assert html =~ "Show Jar"
      assert html =~ jar.name
    end

    test "updates jar within modal", %{conn: conn, jar: jar} do
      {:ok, show_live, _html} = live(conn, ~p"/jars/#{jar}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Jar"

      assert_patch(show_live, ~p"/jars/#{jar}/show/edit")

      assert show_live
             |> form("#jar-form", jar: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#jar-form", jar: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/jars/#{jar}")

      html = render(show_live)
      assert html =~ "Jar updated successfully"
      assert html =~ "some updated name"
    end
  end
end
