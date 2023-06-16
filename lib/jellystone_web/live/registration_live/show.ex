defmodule JellystoneWeb.RegistrationLive.Show do
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
     |> assign(:registration, Databases.get_registration!(id))}
  end

  defp page_title(:show), do: "Show Registration"
  defp page_title(:edit), do: "Edit Registration"
end
