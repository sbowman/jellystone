defmodule JellystoneWeb.NamespaceLive.Show do
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
     |> assign(:namespace, Databases.get_namespace!(id))}
  end

  defp page_title(:show), do: "Show Namespace"
  defp page_title(:edit), do: "Edit Namespace"
end
