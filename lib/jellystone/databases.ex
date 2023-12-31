defmodule Jellystone.Databases do
  @moduledoc """
  The Databases context.
  """

  import Ecto.Query, warn: false
  alias Jellystone.Repo

  alias Jellystone.Databases.Site
  alias Jellystone.Databases.Namespace
  alias Jellystone.Databases.Deployment
  alias Jellystone.Databases.Registration

  @doc """
  Returns the list of sites.

  ## Examples

      iex> list_sites()
      [%Site{}, ...]

  """
  def list_sites do
    total_namespaces_by_site =
      from(n in Namespace,
        group_by: n.site_id,
        select: %{
          site_id: n.site_id,
          total_namespaces: count(n.id)
        }
      )

    Repo.all(
      from(s in Site,
        left_join: total in subquery(total_namespaces_by_site),
        on: total.site_id == s.id,
        order_by: :name,
        select: %Site{s | total_namespaces: total.total_namespaces}
      )
    )

    # Repo.all(
    #   from s in Site,
    #     order_by: :name,
    #     preload: [:namespaces]
    # )
  end

  @doc """
  Gets a single site.

  Raises `Ecto.NoResultsError` if the Site does not exist.

  ## Examples

      iex> get_site!(123)
      %Site{}

      iex> get_site!(456)
      ** (Ecto.NoResultsError)

  """
  def get_site!(id) do
    Site
    |> Repo.get!(id)

    # namespaces = from(namespace in Namespace, order_by: :name)

    # Site
    # |> Repo.get!(id)
    # |> Repo.preload(namespaces: namespaces)

    # |> Repo.preload(:namespaces)
  end

  def site_by_name!(site_name) do
    Site
    |> Repo.get_by!(name: site_name)
  end

  @doc """
  Creates a site.

  ## Examples

      iex> create_site(%{field: value})
      {:ok, %Site{}}

      iex> create_site(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_site(attrs \\ %{}) do
    %Site{}
    |> Site.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a site.

  ## Examples

      iex> update_site(site, %{field: new_value})
      {:ok, %Site{}}

      iex> update_site(site, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_site(%Site{} = site, attrs) do
    site
    |> Site.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a site.

  ## Examples

      iex> delete_site(site)
      {:ok, %Site{}}

      iex> delete_site(site)
      {:error, %Ecto.Changeset{}}

  """
  def delete_site(%Site{} = site) do
    Repo.delete(site)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking site changes.

  ## Examples

      iex> change_site(site)
      %Ecto.Changeset{data: %Site{}}

  """
  def change_site(%Site{} = site, attrs \\ %{}) do
    Site.changeset(site, attrs)
  end

  alias Jellystone.Databases.Namespace

  @doc """
  Returns the list of namespaces.

  ## Examples

      iex> list_namespaces()
      [%Namespace{}, ...]

  """
  def list_namespaces do
    Repo.all(Namespace)
  end

  def list_namespaces(%Site{id: site_id}) do
    total_deployments_by_site =
      from(d in Deployment,
        group_by: d.namespace_id,
        select: %{
          namespace_id: d.namespace_id,
          total_deployments: count(d.id)
        }
      )

    Repo.all(
      from(n in Namespace,
        left_join: total in subquery(total_deployments_by_site),
        on: total.namespace_id == n.id,
        where: n.site_id == ^site_id,
        order_by: :name,
        select: %Namespace{n | total_deployments: total.total_deployments}
      )
    )

    # Repo.all(
    #   from n in Namespace,
    #     where: n.site_id == ^site_id,
    #     select: n
    # )
  end

  @doc """
  Gets a single namespace.

  Raises `Ecto.NoResultsError` if the Namespace does not exist.

  ## Examples

      iex> get_namespace!(123)
      %Namespace{}

      iex> get_namespace!(456)
      ** (Ecto.NoResultsError)

  """
  def get_namespace!(id), do: Repo.get!(Namespace, id)

  def ns_by_name!(namespace_name, %Site{} = site) do
    Namespace
    |> Repo.get_by!(name: namespace_name, site_id: site.id)
  end

  # Repo.all(
  #   from n in Namespace,
  #     where: n.site_id == ^site_id,
  #     select: n

  @doc """
  Creates a namespace.

  ## Examples

      iex> create_namespace(%{field: value})
      {:ok, %Namespace{}}

      iex> create_namespace(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_namespace(attrs \\ %{}) do
    %Namespace{}
    |> Namespace.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a namespace.

  ## Examples

      iex> update_namespace(namespace, %{field: new_value})
      {:ok, %Namespace{}}

      iex> update_namespace(namespace, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_namespace(%Namespace{} = namespace, attrs) do
    namespace
    |> Namespace.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a namespace.

  ## Examples

      iex> delete_namespace(namespace)
      {:ok, %Namespace{}}

      iex> delete_namespace(namespace)
      {:error, %Ecto.Changeset{}}

  """
  def delete_namespace(%Namespace{} = namespace) do
    Repo.delete(namespace)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking namespace changes.

  ## Examples

      iex> change_namespace(namespace)
      %Ecto.Changeset{data: %Namespace{}}

  """
  def change_namespace(%Namespace{} = namespace, attrs \\ %{}) do
    Namespace.changeset(namespace, attrs)
  end

  alias Jellystone.Databases.Deployment

  @doc """
  Returns the list of deployments.

  ## Examples

      iex> list_deployments()
      [%Deployment{}, ...]

  """
  def list_deployments(%Namespace{id: namespace_id}) do
    total_databases_by_site =
      from(r in Registration,
        group_by: r.deployment_id,
        select: %{
          deployment_id: r.deployment_id,
          total_databases: count(r.id)
        }
      )

    Repo.all(
      from(d in Deployment,
        left_join: total in subquery(total_databases_by_site),
        on: total.deployment_id == d.id,
        where: d.namespace_id == ^namespace_id,
        order_by: :name,
        select: %Deployment{d | total_databases: total.total_databases}
      )
    )

    # Repo.all(
    #   from d in Deployment,
    #     where: d.namespace_id == ^namespace_id,
    #     select: d
    # )
  end

  def list_deployments do
    Repo.all(Deployment)
  end

  @doc """
  Gets a single deployment.

  Raises `Ecto.NoResultsError` if the Deployment does not exist.

  ## Examples

      iex> get_deployment!(123)
      %Deployment{}

      iex> get_deployment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_deployment!(id), do: Repo.get!(Deployment, id)

  def deployment_by_name!(deployment_name, %Namespace{} = namespace) do
    Deployment
    |> Repo.get_by(name: deployment_name, namespace_id: namespace.id)
  end

  @doc """
  Creates a deployment.

  ## Examples

      iex> create_deployment(%{field: value})
      {:ok, %Deployment{}}

      iex> create_deployment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_deployment(attrs \\ %{}) do
    %Deployment{}
    |> Deployment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a deployment.

  ## Examples

      iex> update_deployment(deployment, %{field: new_value})
      {:ok, %Deployment{}}

      iex> update_deployment(deployment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_deployment(%Deployment{} = deployment, attrs) do
    deployment
    |> Deployment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a deployment.

  ## Examples

      iex> delete_deployment(deployment)
      {:ok, %Deployment{}}

      iex> delete_deployment(deployment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_deployment(%Deployment{} = deployment) do
    Repo.delete(deployment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking deployment changes.

  ## Examples

      iex> change_deployment(deployment)
      %Ecto.Changeset{data: %Deployment{}}

  """
  def change_deployment(%Deployment{} = deployment, attrs \\ %{}) do
    Deployment.changeset(deployment, attrs)
  end

  alias Jellystone.Databases.Registration

  @doc """
  Returns the list of registrations.

  ## Examples

      iex> list_registrations()
      [%Registration{}, ...]

  """
  def list_registrations(%Deployment{id: deployment_id}) do
    Repo.all(
      from(r in Registration,
        where: r.deployment_id == ^deployment_id,
        order_by: :name
      )
    )
  end

  def list_registrations do
    Repo.all(Registration)
  end

  @doc """
  Gets a single registration.

  Raises `Ecto.NoResultsError` if the Registration does not exist.

  ## Examples

      iex> get_registration!(123)
      %Registration{}

      iex> get_registration!(456)
      ** (Ecto.NoResultsError)

  """
  def get_registration!(id), do: Repo.get!(Registration, id)

  @doc """
  Creates a registration.

  ## Examples

      iex> create_registration(%{field: value})
      {:ok, %Registration{}}

      iex> create_registration(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_registration(attrs \\ %{}) do
    %Registration{}
    |> Registration.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a registration.

  ## Examples

      iex> update_registration(registration, %{field: new_value})
      {:ok, %Registration{}}

      iex> update_registration(registration, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_registration(%Registration{} = registration, attrs) do
    registration
    |> Registration.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a registration.

  ## Examples

      iex> delete_registration(registration)
      {:ok, %Registration{}}

      iex> delete_registration(registration)
      {:error, %Ecto.Changeset{}}

  """
  def delete_registration(%Registration{} = registration) do
    Repo.delete(registration)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking registration changes.

  ## Examples

      iex> change_registration(registration)
      %Ecto.Changeset{data: %Registration{}}

  """
  def change_registration(%Registration{} = registration, attrs \\ %{}) do
    Registration.changeset(registration, attrs)
  end

  alias Jellystone.Databases.Tag

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

  """
  def list_tags do
    Repo.all(Tag)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{data: %Tag{}}

  """
  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end
end
