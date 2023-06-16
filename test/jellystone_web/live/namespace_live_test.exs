defmodule JellystoneWeb.NamespaceLiveTest do
  use JellystoneWeb.ConnCase

  import Phoenix.LiveViewTest
  import Jellystone.DatabasesFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_namespace(_) do
    namespace = namespace_fixture()
    %{namespace: namespace}
  end

  describe "Index" do
    setup [:create_namespace]

    test "lists all namespaces", %{conn: conn, namespace: namespace} do
      {:ok, _index_live, html} = live(conn, ~p"/namespaces")

      assert html =~ "Listing Namespaces"
      assert html =~ namespace.name
    end

    test "saves new namespace", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/namespaces")

      assert index_live |> element("a", "New Namespace") |> render_click() =~
               "New Namespace"

      assert_patch(index_live, ~p"/namespaces/new")

      assert index_live
             |> form("#namespace-form", namespace: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#namespace-form", namespace: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/namespaces")

      html = render(index_live)
      assert html =~ "Namespace created successfully"
      assert html =~ "some name"
    end

    test "updates namespace in listing", %{conn: conn, namespace: namespace} do
      {:ok, index_live, _html} = live(conn, ~p"/namespaces")

      assert index_live |> element("#namespaces-#{namespace.id} a", "Edit") |> render_click() =~
               "Edit Namespace"

      assert_patch(index_live, ~p"/namespaces/#{namespace}/edit")

      assert index_live
             |> form("#namespace-form", namespace: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#namespace-form", namespace: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/namespaces")

      html = render(index_live)
      assert html =~ "Namespace updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes namespace in listing", %{conn: conn, namespace: namespace} do
      {:ok, index_live, _html} = live(conn, ~p"/namespaces")

      assert index_live |> element("#namespaces-#{namespace.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#namespaces-#{namespace.id}")
    end
  end

  describe "Show" do
    setup [:create_namespace]

    test "displays namespace", %{conn: conn, namespace: namespace} do
      {:ok, _show_live, html} = live(conn, ~p"/namespaces/#{namespace}")

      assert html =~ "Show Namespace"
      assert html =~ namespace.name
    end

    test "updates namespace within modal", %{conn: conn, namespace: namespace} do
      {:ok, show_live, _html} = live(conn, ~p"/namespaces/#{namespace}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Namespace"

      assert_patch(show_live, ~p"/namespaces/#{namespace}/show/edit")

      assert show_live
             |> form("#namespace-form", namespace: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#namespace-form", namespace: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/namespaces/#{namespace}")

      html = render(show_live)
      assert html =~ "Namespace updated successfully"
      assert html =~ "some updated name"
    end
  end
end
