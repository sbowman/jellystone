defmodule Jellystone.DatabasesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Jellystone.Databases` context.
  """

  @doc """
  Generate a unique site name.
  """
  def unique_site_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a site.
  """
  def site_fixture(attrs \\ %{}) do
    {:ok, site} =
      attrs
      |> Enum.into(%{
        name: unique_site_name()
      })
      |> Jellystone.Databases.create_site()

    site
  end

  @doc """
  Generate a unique namespace name.
  """
  def unique_namespace_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a namespace.
  """
  def namespace_fixture(attrs \\ %{}) do
    {:ok, namespace} =
      attrs
      |> Enum.into(%{
        name: unique_namespace_name()
      })
      |> Jellystone.Databases.create_namespace()

    namespace
  end

  @doc """
  Generate a unique deployment name.
  """
  def unique_deployment_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a deployment.
  """
  def deployment_fixture(attrs \\ %{}) do
    {:ok, deployment} =
      attrs
      |> Enum.into(%{
        name: unique_deployment_name()
      })
      |> Jellystone.Databases.create_deployment()

    deployment
  end

  @doc """
  Generate a unique registration name.
  """
  def unique_registration_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a registration.
  """
  def registration_fixture(attrs \\ %{}) do
    {:ok, registration} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: unique_registration_name()
      })
      |> Jellystone.Databases.create_registration()

    registration
  end

  @doc """
  Generate a unique tag name.
  """
  def unique_tag_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        name: unique_tag_name()
      })
      |> Jellystone.Databases.create_tag()

    tag
  end

  @doc """
  Generate a database_tag.
  """
  def database_tag_fixture(attrs \\ %{}) do
    {:ok, database_tag} =
      attrs
      |> Enum.into(%{

      })
      |> Jellystone.Databases.create_database_tag()

    database_tag
  end
end
