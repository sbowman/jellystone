defmodule JellystoneWeb.DeploymentLive.Show do
  use JellystoneWeb, :live_view

  alias Jellystone.Databases
  alias Jellystone.Databases.Site
  alias Jellystone.Databases.Namespace
  alias Jellystone.Databases.Deployment
  alias Jellystone.Databases.Registration

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _url, socket) do
    deployment = Databases.get_deployment!(id)
    namespace = Databases.get_namespace!(deployment.namespace_id)
    site = Databases.get_site!(namespace.site_id)

    # {:noreply,
    #  socket
    #  |> assign(:page_title, "Deployment #{deployment.name}")
    #  |> assign(:site, site)
    #  |> assign(:namespace, namespace)
    #  |> assign(:deployment, deployment)
    #  |> stream(:registrations, Databases.list_registrations(deployment))}

    reply_params(socket, site, namespace, deployment, params)
  end

  @impl true
  def handle_params(
        %{
          "site_name" => site_name,
          "namespace_name" => namespace_name,
          "deployment_name" => deployment_name
        } = params,
        _url,
        socket
      ) do
    site = Databases.site_by_name!(site_name)
    namespace = Databases.ns_by_name!(namespace_name, site)
    deployment = Databases.deployment_by_name!(deployment_name, namespace)

    reply_params(socket, site, namespace, deployment, params)
  end

  defp reply_params(
         socket,
         %Site{} = site,
         %Namespace{} = namespace,
         %Deployment{} = deployment,
         params
       ) do
    socket =
      socket
      |> assign(:page_title, "Deployment #{deployment.name}")
      |> assign(:site, site)
      |> assign(:namespace, namespace)
      |> assign(:deployment, deployment)
      |> stream(:registrations, Databases.list_registrations(deployment))

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Deployment #{socket.assigns.deployment.name}")
  end

  defp apply_action(socket, :edit, _params) do
    socket
    |> assign(:page_title, "Edit Deployment")
  end

  defp apply_action(socket, :new_registration, %{"id" => id}) do
    socket
    |> assign(:page_title, "Provision Database")
    |> assign(:registration, %Registration{deployment_id: id})
  end

  defp apply_action(socket, :edit_registration, %{"registration_id" => id}) do
    socket
    |> assign(:page_title, "Edit Database Registration")
    |> assign(:registration, Databases.get_registration!(id))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    registration = Databases.get_registration!(id)
    {:ok, _} = Databases.delete_registration(registration)
    {:noreply, stream_delete(socket, :registrations, registration)}
  end

  @impl true
  def handle_event("new_registration", _params, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Provision Database")
     |> assign(:live_action, :new_registration)
     |> assign(:registration, %Registration{deployment_id: socket.assigns.deployment.id})}
  end

  @impl true
  def handle_info({JellystoneWeb.DeploymentLive.FormComponent, {:saved, registration}}, socket) do
    if socket.assigns.deployment.id == registration.deployment_id do
      {:noreply, stream_insert(socket, :registrations, registration)}
    else
      {:noreply, socket}
    end
  end
end
