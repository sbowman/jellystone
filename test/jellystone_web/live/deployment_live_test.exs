defmodule JellystoneWeb.DeploymentLiveTest do
  use JellystoneWeb.ConnCase

  import Phoenix.LiveViewTest
  import Jellystone.DatabasesFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_deployment(_) do
    deployment = deployment_fixture()
    %{deployment: deployment}
  end

  describe "Index" do
    setup [:create_deployment]

    test "lists all deployments", %{conn: conn, deployment: deployment} do
      {:ok, _index_live, html} = live(conn, ~p"/deployments")

      assert html =~ "Listing Deployments"
      assert html =~ deployment.name
    end

    test "saves new deployment", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/deployments")

      assert index_live |> element("a", "New Deployment") |> render_click() =~
               "New Deployment"

      assert_patch(index_live, ~p"/deployments/new")

      assert index_live
             |> form("#deployment-form", deployment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#deployment-form", deployment: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/deployments")

      html = render(index_live)
      assert html =~ "Deployment created successfully"
      assert html =~ "some name"
    end

    test "updates deployment in listing", %{conn: conn, deployment: deployment} do
      {:ok, index_live, _html} = live(conn, ~p"/deployments")

      assert index_live |> element("#deployments-#{deployment.id} a", "Edit") |> render_click() =~
               "Edit Deployment"

      assert_patch(index_live, ~p"/deployments/#{deployment}/edit")

      assert index_live
             |> form("#deployment-form", deployment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#deployment-form", deployment: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/deployments")

      html = render(index_live)
      assert html =~ "Deployment updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes deployment in listing", %{conn: conn, deployment: deployment} do
      {:ok, index_live, _html} = live(conn, ~p"/deployments")

      assert index_live |> element("#deployments-#{deployment.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#deployments-#{deployment.id}")
    end
  end

  describe "Show" do
    setup [:create_deployment]

    test "displays deployment", %{conn: conn, deployment: deployment} do
      {:ok, _show_live, html} = live(conn, ~p"/deployments/#{deployment}")

      assert html =~ "Show Deployment"
      assert html =~ deployment.name
    end

    test "updates deployment within modal", %{conn: conn, deployment: deployment} do
      {:ok, show_live, _html} = live(conn, ~p"/deployments/#{deployment}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Deployment"

      assert_patch(show_live, ~p"/deployments/#{deployment}/show/edit")

      assert show_live
             |> form("#deployment-form", deployment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#deployment-form", deployment: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/deployments/#{deployment}")

      html = render(show_live)
      assert html =~ "Deployment updated successfully"
      assert html =~ "some updated name"
    end
  end
end
