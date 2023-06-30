defmodule JellystoneWeb.RegistrationLive.FormComponent do
  use JellystoneWeb, :live_component

  import Ecto.Query, only: [from: 2], warn: false

  alias Jellystone.Databases
  alias Jellystone.Databases.Deployment
  alias Jellystone.Databases.Namespace
  alias Jellystone.Databases.Site

  @impl true
  def render(assigns) do
    deployments =
      Jellystone.Repo.all(
        from(d in Deployment,
          join: n in Namespace,
          on: d.namespace_id == n.id,
          join: s in Site,
          on: n.site_id == s.id,
          order_by: [s.name, n.name, d.name],
          select: %Deployment{d | namespace: %Namespace{n | site: s}}
        )
      )

    groups =
      Map.from_keys(
        Enum.map(deployments, fn d -> "#{d.namespace.site.name} > #{d.namespace.name}" end),
        []
      )

    deployments =
      Enum.reduce(deployments, groups, fn d, acc ->
        name = "#{d.namespace.site.name} > #{d.namespace.name}"
        %{acc | name => acc[name] ++ [{d.name, d.id}]}
      end)

    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>What would you like to call this database?</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:deployment_id]} type="select" label="Deployment" options={deployments} />

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
    case socket.assigns.action do
      :new_registration ->
        save_registration(socket, :new, registration_params)

      :edit_registration ->
        save_registration(socket, :edit, registration_params)

      _ ->
        save_registration(socket, socket.assigns.action, registration_params)
    end
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
    IO.puts("Saving!!!!")
    IO.inspect(registration_params)

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
