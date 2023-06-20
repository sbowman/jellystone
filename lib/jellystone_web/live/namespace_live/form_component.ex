defmodule JellystoneWeb.NamespaceLive.FormComponent do
  use JellystoneWeb, :live_component

  alias Jellystone.Databases
  alias Jellystone.Databases.Site

  @impl true
  def render(assigns) do
    sites = Jellystone.Repo.all(Site)
    sites = Enum.map(sites, &{&1.name, &1.id})

    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>What's the name of the namespace associated with this site?</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="namespace-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:site_id]} type="select" label="Site" options={sites} />

        <:actions>
          <.button phx-disable-with="Saving...">Save Namespace</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{namespace: namespace} = assigns, socket) do
    changeset = Databases.change_namespace(namespace)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"namespace" => namespace_params}, socket) do
    changeset =
      socket.assigns.namespace
      |> Databases.change_namespace(namespace_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"namespace" => namespace_params}, socket) do
    case socket.assigns.action do
      :new_namespace ->
        save_namespace(socket, :new, namespace_params)

      :edit_namespace ->
        save_namespace(socket, :edit, namespace_params)

      _ ->
        save_namespace(socket, socket.assigns.action, namespace_params)
    end
  end

  defp save_namespace(socket, :edit, namespace_params) do
    case Databases.update_namespace(socket.assigns.namespace, namespace_params) do
      {:ok, namespace} ->
        notify_parent({:saved, namespace})

        {:noreply,
         socket
         |> put_flash(:info, "Namespace \"#{namespace.name}\" updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_namespace(socket, :new, namespace_params) do
    case Databases.create_namespace(namespace_params) do
      {:ok, namespace} ->
        notify_parent({:saved, namespace})

        {:noreply,
         socket
         |> put_flash(:info, "Namespace \"#{namespace.name}\" created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)

        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
