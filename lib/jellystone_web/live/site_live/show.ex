defmodule JellystoneWeb.SiteLive.Show do
  use JellystoneWeb, :live_view

  alias Jellystone.Databases
  alias Jellystone.Databases.Namespace

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _url, socket) do
    socket =
      socket
      |> assign(:site, Databases.get_site!(id))

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Site #{socket.assigns.site.name}")
  end

  def apply_action(socket, :edit, _params) do
    socket
    |> assign(:page_title, "Edit Site")
  end

  def apply_action(socket, :new_namespace, %{"id" => id}) do
    socket
    |> assign(:page_title, "Add Namespace")
    |> assign(:namespace, %Namespace{site_id: id})
  end

  def apply_action(socket, :edit_namespace, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Namespace")
    |> assign(:namespace, Databases.get_namespace!(id))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    namespace = Databases.get_namespace!(id)
    {:ok, _} = Databases.delete_namespace(namespace)

    # TODO: need namespaces to be a stream!
    {:noreply, stream_delete(socket, :namespaces, namespace)}
  end
end
