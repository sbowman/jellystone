defmodule JellystoneWeb.SiteLive.Show do
  use JellystoneWeb, :live_view

  alias Jellystone.Databases
  alias Jellystone.Databases.Namespace

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => _} = params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, "Show Site")
    |> assign(:site, Databases.get_site!(id))
  end

  def apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Site")
    |> assign(:site, Databases.get_site!(id))
  end

  def apply_action(socket, :new_namespace, %{"id" => id}) do
    socket
    |> assign(:page_title, "Add Namespace")
    |> assign(:site, Databases.get_site!(id))
    |> assign(:namespace, %Namespace{})
  end
end
