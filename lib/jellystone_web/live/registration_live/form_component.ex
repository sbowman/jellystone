defmodule JellystoneWeb.RegistrationLive.FormComponent do
  use JellystoneWeb, :live_component

  alias Jellystone.Databases

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage registration records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Registration</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{registration: registration} = assigns, socket) do
    changeset = Databases.change_registration(registration)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"registration" => registration_params}, socket) do
    changeset =
      socket.assigns.registration
      |> Databases.change_registration(registration_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"registration" => registration_params}, socket) do
    save_registration(socket, socket.assigns.action, registration_params)
  end

  defp save_registration(socket, :edit, registration_params) do
    case Databases.update_registration(socket.assigns.registration, registration_params) do
      {:ok, registration} ->
        notify_parent({:saved, registration})

        {:noreply,
         socket
         |> put_flash(:info, "Registration updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_registration(socket, :new, registration_params) do
    case Databases.create_registration(registration_params) do
      {:ok, registration} ->
        notify_parent({:saved, registration})

        {:noreply,
         socket
         |> put_flash(:info, "Registration created successfully")
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
