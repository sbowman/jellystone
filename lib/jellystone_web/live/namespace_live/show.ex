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

    reply_params(socket, site, namespace, params)
  end

  @impl true
  def handle_params(
        %{"site_name" => site_name, "namespace_name" => namespace_name} = params,
        _url,
        socket
      ) do
    site = Databases.site_by_name!(site_name)
    namespace = Databases.ns_by_name!(namespace_name, site)

    reply_params(socket, site, namespace, params)
  end

  defp reply_params(socket, site, namespace, params) do
    socket =
      socket
      |> assign(:page_title, "Namespace #{socket.assigns.live_action}")
      |> assign(:namespace, namespace)
      |> assign(:site, site)
      |> stream(:deployments, Databases.list_deployments(namespace))

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Namespace #{socket.assigns.namespace.name}")
  end

  defp apply_action(socket, :edit, _params) do
    socket
    |> assign(:page_title, "Edit Namespace")
  end

  defp apply_action(socket, :new_deployment, %{"id" => id}) do
    socket
    |> assign(:page_title, "Add Deployment")
    |> assign(:deployment, %Deployment{namespace_id: id})
  end

  defp apply_action(socket, :edit_deployment, %{"deployment_id" => id}) do
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
  def handle_event("new_deployment", _params, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Add Deployment")
     |> assign(:live_action, :new_deployment)
     |> assign(:deployment, %Deployment{namespace_id: socket.assigns.namespace.id})}
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
