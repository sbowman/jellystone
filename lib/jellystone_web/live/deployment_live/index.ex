defmodule JellystoneWeb.DeploymentLive.Index do
  use JellystoneWeb, :live_view

  alias Jellystone.Databases
  alias Jellystone.Databases.Deployment

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :deployments, Databases.list_deployments())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Deployment")
    |> assign(:deployment, Databases.get_deployment!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Deployment")
    |> assign(:deployment, %Deployment{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Deployments")
    |> assign(:deployment, nil)
  end

  @impl true
  def handle_info({JellystoneWeb.DeploymentLive.FormComponent, {:saved, deployment}}, socket) do
    {:noreply, stream_insert(socket, :deployments, deployment)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    deployment = Databases.get_deployment!(id)
    {:ok, _} = Databases.delete_deployment(deployment)

    {:noreply, stream_delete(socket, :deployments, deployment)}
  end
end
