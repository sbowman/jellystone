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
    site = Databases.get_site!(id)

    socket =
      socket
      |> assign(:site, site)
      |> stream(:namespaces, Databases.list_namespaces(site))

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_params(%{"site_name" => site_name} = params, _url, socket) do
    site = Databases.site_by_name!(site_name)

    socket =
      socket
      |> assign(:site, site)
      |> stream(:namespaces, Databases.list_namespaces(site))

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

  def apply_action(socket, :edit_namespace, %{"nsid" => id}) do
    socket
    |> assign(:page_title, "Edit Namespace")
    |> assign(:namespace, Databases.get_namespace!(id))
  end

  @impl true
  def handle_event("new_namespace", _params, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Add Namespace")
     |> assign(:live_action, :new_namespace)
     |> assign(:namespace, %Namespace{site_id: socket.assigns.site.id})}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    namespace = Databases.get_namespace!(id)
    {:ok, _} = Databases.delete_namespace(namespace)
    {:noreply, stream_delete(socket, :namespaces, namespace)}
  end

  @impl true
  def handle_info({JellystoneWeb.NamespaceLive.FormComponent, {:saved, namespace}}, socket) do
    if socket.assigns.site.id == namespace.site_id do
      {:noreply, stream_insert(socket, :namespaces, namespace)}
    else
      {:noreply, socket}
    end
  end
end
