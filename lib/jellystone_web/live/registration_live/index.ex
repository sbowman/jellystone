defmodule JellystoneWeb.RegistrationLive.Index do
  use JellystoneWeb, :live_view

  alias Jellystone.Databases
  alias Jellystone.Databases.Registration

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :registrations, Databases.list_registrations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Registration")
    |> assign(:registration, Databases.get_registration!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Registration")
    |> assign(:registration, %Registration{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Registrations")
    |> assign(:registration, nil)
  end

  @impl true
  def handle_info({JellystoneWeb.RegistrationLive.FormComponent, {:saved, registration}}, socket) do
    {:noreply, stream_insert(socket, :registrations, registration)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    registration = Databases.get_registration!(id)
    {:ok, _} = Databases.delete_registration(registration)

    {:noreply, stream_delete(socket, :registrations, registration)}
  end
end
