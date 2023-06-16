defmodule JellystoneWeb.DatabaseTagLiveTest do
  use JellystoneWeb.ConnCase

  import Phoenix.LiveViewTest
  import Jellystone.DatabasesFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_database_tag(_) do
    database_tag = database_tag_fixture()
    %{database_tag: database_tag}
  end

  describe "Index" do
    setup [:create_database_tag]

    test "lists all database_tags", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/database_tags")

      assert html =~ "Listing Database tags"
    end

    test "saves new database_tag", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/database_tags")

      assert index_live |> element("a", "New Database tag") |> render_click() =~
               "New Database tag"

      assert_patch(index_live, ~p"/database_tags/new")

      assert index_live
             |> form("#database_tag-form", database_tag: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#database_tag-form", database_tag: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/database_tags")

      html = render(index_live)
      assert html =~ "Database tag created successfully"
    end

    test "updates database_tag in listing", %{conn: conn, database_tag: database_tag} do
      {:ok, index_live, _html} = live(conn, ~p"/database_tags")

      assert index_live |> element("#database_tags-#{database_tag.id} a", "Edit") |> render_click() =~
               "Edit Database tag"

      assert_patch(index_live, ~p"/database_tags/#{database_tag}/edit")

      assert index_live
             |> form("#database_tag-form", database_tag: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#database_tag-form", database_tag: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/database_tags")

      html = render(index_live)
      assert html =~ "Database tag updated successfully"
    end

    test "deletes database_tag in listing", %{conn: conn, database_tag: database_tag} do
      {:ok, index_live, _html} = live(conn, ~p"/database_tags")

      assert index_live |> element("#database_tags-#{database_tag.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#database_tags-#{database_tag.id}")
    end
  end

  describe "Show" do
    setup [:create_database_tag]

    test "displays database_tag", %{conn: conn, database_tag: database_tag} do
      {:ok, _show_live, html} = live(conn, ~p"/database_tags/#{database_tag}")

      assert html =~ "Show Database tag"
    end

    test "updates database_tag within modal", %{conn: conn, database_tag: database_tag} do
      {:ok, show_live, _html} = live(conn, ~p"/database_tags/#{database_tag}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Database tag"

      assert_patch(show_live, ~p"/database_tags/#{database_tag}/show/edit")

      assert show_live
             |> form("#database_tag-form", database_tag: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#database_tag-form", database_tag: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/database_tags/#{database_tag}")

      html = render(show_live)
      assert html =~ "Database tag updated successfully"
    end
  end
end
