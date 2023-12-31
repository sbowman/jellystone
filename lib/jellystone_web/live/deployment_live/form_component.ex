defmodule JellystoneWeb.DeploymentLive.FormComponent do
  use JellystoneWeb, :live_component

  import Ecto.Query, only: [from: 2], warn: false

  alias Jellystone.Databases
  alias Jellystone.Databases.Namespace
  alias Jellystone.Databases.Site

  @impl true
  def render(assigns) do
    namespaces =
      Jellystone.Repo.all(
        from(n in Namespace,
          join: s in Site,
          on: n.site_id == s.id,
          order_by: [s.name, n.name],
          select: %Namespace{n | site: s}
        )
      )

    groups = Map.from_keys(Enum.map(namespaces, fn n -> n.site.name end), [])

    namespaces =
      Enum.reduce(namespaces, groups, fn n, acc ->
        %{acc | n.site.name => acc[n.site.name] ++ [{n.name, n.id}]}
      end)

    # namespaces = Enum.map(namespaces, &{"#{&1.name} (#{&1.site.name})", &1.id})

    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>What's the name of this deployment?</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="deployment-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:namespace_id]} type="select" label="Namespace" options={namespaces} />

        <:actions>
          <.button phx-disable-with="Saving...">Save Deployment</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{deployment: deployment} = assigns, socket) do
    changeset = Databases.change_deployment(deployment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"deployment" => deployment_params}, socket) do
    changeset =
      socket.assigns.deployment
      |> Databases.change_deployment(deployment_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"deployment" => deployment_params}, socket) do
    case socket.assigns.action do
      :new_deployment ->
        save_deployment(socket, :new, deployment_params)

      :edit_deployment ->
        save_deployment(socket, :edit, deployment_params)

      _ ->
        save_deployment(socket, socket.assigns.action, deployment_params)
    end
  end

  defp save_deployment(socket, :edit, deployment_params) do
    case Databases.update_deployment(socket.assigns.deployment, deployment_params) do
      {:ok, deployment} ->
        notify_parent({:saved, deployment})

        {:noreply,
         socket
         |> put_flash(:info, "Deployment \"#{deployment.name}\" updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_deployment(socket, :new, deployment_params) do
    case Databases.create_deployment(deployment_params) do
      {:ok, deployment} ->
        notify_parent({:saved, deployment})

        {:noreply,
         socket
         |> put_flash(:info, "Deployment \"#{deployment.name}\" created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
