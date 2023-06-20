defmodule JellystoneWeb.SiteLive.Index do
  use JellystoneWeb, :live_view

  alias Jellystone.Databases
  alias Jellystone.Databases.Site

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :sites, Databases.list_sites())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Site")
    |> assign(:site, Databases.get_site!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Site")
    |> assign(:site, %Site{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "RDEI Sites")
    |> assign(:site, nil)
  end

  @impl true
  def handle_info({JellystoneWeb.SiteLive.FormComponent, {:saved, site}}, socket) do
    {:noreply, stream_insert(socket, :sites, site)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    site = Databases.get_site!(id)
    {:ok, _} = Databases.delete_site(site)

    {:noreply, stream_delete(socket, :sites, site)}
  end
end
