defmodule JellystoneWeb.NamespaceLive.Show do
  use JellystoneWeb, :live_view

  alias Jellystone.Databases
  alias Jellystone.Databases.Deployment

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _url, socket) do
    namespace = Databases.get_namespace!(id)
    site = Databases.get_site!(namespace.site_id)

    socket =
      socket
      |> assign(:page_title, "Namespace #{socket.assigns.live_action}")
      |> assign(:namespace, namespace)
      |> assign(:site, site)
      |> stream(:deployments, Databases.list_deployments(namespace))

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Namespace #{socket.assigns.namespace.name}")
  end

  def apply_action(socket, :edit, _params) do
    socket
    |> assign(:page_title, "Edit Namespace")
  end

  def apply_action(socket, :new_deployment, %{"id" => id}) do
    socket
    |> assign(:page_title, "Add Deployment")
    |> assign(:deployment, %Deployment{namespace_id: id})
  end

  def apply_action(socket, :edit_deployment, %{"deployment_id" => id}) do
    socket
    |> assign(:page_title, "Edit Deployment")
    |> assign(:deployment, Databases.get_deployment!(id))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    deployment = Databases.get_deployment!(id)
    {:ok, _} = Databases.delete_deployment(deployment)
    {:noreply, stream_delete(socket, :deployments, deployment)}
  end

  @impl true
  def handle_info({JellystoneWeb.DeploymentLive.FormComponent, {:saved, deployment}}, socket) do
    if socket.assigns.namespace.id == deployment.namespace_id do
      {:noreply, stream_insert(socket, :deployments, deployment)}
    else
      {:noreply, socket}
    end
  end
end
