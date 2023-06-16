defmodule JellystoneWeb.DeploymentLive.Show do
  use JellystoneWeb, :live_view

  alias Jellystone.Databases

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:deployment, Databases.get_deployment!(id))}
  end

  defp page_title(:show), do: "Show Deployment"
  defp page_title(:edit), do: "Edit Deployment"
end
