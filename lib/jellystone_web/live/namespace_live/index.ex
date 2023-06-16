defmodule JellystoneWeb.NamespaceLive.Index do
  use JellystoneWeb, :live_view

  alias Jellystone.Databases
  alias Jellystone.Databases.Namespace

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :namespaces, Databases.list_namespaces())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Namespace")
    |> assign(:site, Databases.get_site!(id))
    |> assign(:namespace, Databases.get_namespace!(id))
  end

  defp apply_action(socket, :new, %{"id" => id}) do
    socket
    |> assign(:page_title, "New Namespace")
    |> assign(:site, Databases.get_site!(id))
    |> assign(:namespace, %Namespace{})
  end

  # def apply_action(socket, :edit_site, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit Site")
  #   |> assign(:site, Databases.get_site!(id))
  # end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Show Site")
    |> assign(:namespace, nil)
  end

  @impl true
  def handle_info({JellystoneWeb.NamespaceLive.FormComponent, {:saved, namespace}}, socket) do
    {:noreply, stream_insert(socket, :namespaces, namespace)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    namespace = Databases.get_namespace!(id)
    {:ok, _} = Databases.delete_namespace(namespace)

    {:noreply, stream_delete(socket, :namespaces, namespace)}
  end
end
