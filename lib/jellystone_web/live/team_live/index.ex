defmodule JellystoneWeb.TeamLive.Index do
  use JellystoneWeb, :live_view

  alias Jellystone.Accounts
  alias Jellystone.Accounts.Team

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :teams, Accounts.list_teams())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Team")
    |> assign(:team, Accounts.get_team!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Team")
    |> assign(:team, %Team{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Teams")
    |> assign(:team, nil)
  end

  @impl true
  def handle_info({JellystoneWeb.TeamLive.FormComponent, {:saved, team}}, socket) do
    {:noreply, stream_insert(socket, :teams, team)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    team = Accounts.get_team!(id)
    {:ok, _} = Accounts.delete_team(team)

    {:noreply, stream_delete(socket, :teams, team)}
  end
end
