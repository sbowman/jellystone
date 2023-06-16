defmodule JellystoneWeb.DeploymentLive.FormComponent do
  use JellystoneWeb, :live_component

  alias Jellystone.Databases

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage deployment records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="deployment-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
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
    save_deployment(socket, socket.assigns.action, deployment_params)
  end

  defp save_deployment(socket, :edit, deployment_params) do
    case Databases.update_deployment(socket.assigns.deployment, deployment_params) do
      {:ok, deployment} ->
        notify_parent({:saved, deployment})

        {:noreply,
         socket
         |> put_flash(:info, "Deployment updated successfully")
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
         |> put_flash(:info, "Deployment created successfully")
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
