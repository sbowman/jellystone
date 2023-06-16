defmodule JellystoneWeb.RegistrationLiveTest do
  use JellystoneWeb.ConnCase

  import Phoenix.LiveViewTest
  import Jellystone.DatabasesFixtures

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  defp create_registration(_) do
    registration = registration_fixture()
    %{registration: registration}
  end

  describe "Index" do
    setup [:create_registration]

    test "lists all registrations", %{conn: conn, registration: registration} do
      {:ok, _index_live, html} = live(conn, ~p"/registrations")

      assert html =~ "Listing Registrations"
      assert html =~ registration.description
    end

    test "saves new registration", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/registrations")

      assert index_live |> element("a", "New Registration") |> render_click() =~
               "New Registration"

      assert_patch(index_live, ~p"/registrations/new")

      assert index_live
             |> form("#registration-form", registration: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#registration-form", registration: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/registrations")

      html = render(index_live)
      assert html =~ "Registration created successfully"
      assert html =~ "some description"
    end

    test "updates registration in listing", %{conn: conn, registration: registration} do
      {:ok, index_live, _html} = live(conn, ~p"/registrations")

      assert index_live |> element("#registrations-#{registration.id} a", "Edit") |> render_click() =~
               "Edit Registration"

      assert_patch(index_live, ~p"/registrations/#{registration}/edit")

      assert index_live
             |> form("#registration-form", registration: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#registration-form", registration: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/registrations")

      html = render(index_live)
      assert html =~ "Registration updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes registration in listing", %{conn: conn, registration: registration} do
      {:ok, index_live, _html} = live(conn, ~p"/registrations")

      assert index_live |> element("#registrations-#{registration.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#registrations-#{registration.id}")
    end
  end

  describe "Show" do
    setup [:create_registration]

    test "displays registration", %{conn: conn, registration: registration} do
      {:ok, _show_live, html} = live(conn, ~p"/registrations/#{registration}")

      assert html =~ "Show Registration"
      assert html =~ registration.description
    end

    test "updates registration within modal", %{conn: conn, registration: registration} do
      {:ok, show_live, _html} = live(conn, ~p"/registrations/#{registration}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Registration"

      assert_patch(show_live, ~p"/registrations/#{registration}/show/edit")

      assert show_live
             |> form("#registration-form", registration: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#registration-form", registration: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/registrations/#{registration}")

      html = render(show_live)
      assert html =~ "Registration updated successfully"
      assert html =~ "some updated description"
    end
  end
end
