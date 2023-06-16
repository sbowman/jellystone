defmodule Jellystone.DatabasesTest do
  use Jellystone.DataCase

  alias Jellystone.Databases

  describe "sites" do
    alias Jellystone.Databases.Site

    import Jellystone.DatabasesFixtures

    @invalid_attrs %{name: nil}

    test "list_sites/0 returns all sites" do
      site = site_fixture()
      assert Databases.list_sites() == [site]
    end

    test "get_site!/1 returns the site with given id" do
      site = site_fixture()
      assert Databases.get_site!(site.id) == site
    end

    test "create_site/1 with valid data creates a site" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Site{} = site} = Databases.create_site(valid_attrs)
      assert site.name == "some name"
    end

    test "create_site/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Databases.create_site(@invalid_attrs)
    end

    test "update_site/2 with valid data updates the site" do
      site = site_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Site{} = site} = Databases.update_site(site, update_attrs)
      assert site.name == "some updated name"
    end

    test "update_site/2 with invalid data returns error changeset" do
      site = site_fixture()
      assert {:error, %Ecto.Changeset{}} = Databases.update_site(site, @invalid_attrs)
      assert site == Databases.get_site!(site.id)
    end

    test "delete_site/1 deletes the site" do
      site = site_fixture()
      assert {:ok, %Site{}} = Databases.delete_site(site)
      assert_raise Ecto.NoResultsError, fn -> Databases.get_site!(site.id) end
    end

    test "change_site/1 returns a site changeset" do
      site = site_fixture()
      assert %Ecto.Changeset{} = Databases.change_site(site)
    end
  end

  describe "namespaces" do
    alias Jellystone.Databases.Namespace

    import Jellystone.DatabasesFixtures

    @invalid_attrs %{name: nil}

    test "list_namespaces/0 returns all namespaces" do
      namespace = namespace_fixture()
      assert Databases.list_namespaces() == [namespace]
    end

    test "get_namespace!/1 returns the namespace with given id" do
      namespace = namespace_fixture()
      assert Databases.get_namespace!(namespace.id) == namespace
    end

    test "create_namespace/1 with valid data creates a namespace" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Namespace{} = namespace} = Databases.create_namespace(valid_attrs)
      assert namespace.name == "some name"
    end

    test "create_namespace/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Databases.create_namespace(@invalid_attrs)
    end

    test "update_namespace/2 with valid data updates the namespace" do
      namespace = namespace_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Namespace{} = namespace} = Databases.update_namespace(namespace, update_attrs)
      assert namespace.name == "some updated name"
    end

    test "update_namespace/2 with invalid data returns error changeset" do
      namespace = namespace_fixture()
      assert {:error, %Ecto.Changeset{}} = Databases.update_namespace(namespace, @invalid_attrs)
      assert namespace == Databases.get_namespace!(namespace.id)
    end

    test "delete_namespace/1 deletes the namespace" do
      namespace = namespace_fixture()
      assert {:ok, %Namespace{}} = Databases.delete_namespace(namespace)
      assert_raise Ecto.NoResultsError, fn -> Databases.get_namespace!(namespace.id) end
    end

    test "change_namespace/1 returns a namespace changeset" do
      namespace = namespace_fixture()
      assert %Ecto.Changeset{} = Databases.change_namespace(namespace)
    end
  end

  describe "deployments" do
    alias Jellystone.Databases.Deployment

    import Jellystone.DatabasesFixtures

    @invalid_attrs %{name: nil}

    test "list_deployments/0 returns all deployments" do
      deployment = deployment_fixture()
      assert Databases.list_deployments() == [deployment]
    end

    test "get_deployment!/1 returns the deployment with given id" do
      deployment = deployment_fixture()
      assert Databases.get_deployment!(deployment.id) == deployment
    end

    test "create_deployment/1 with valid data creates a deployment" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Deployment{} = deployment} = Databases.create_deployment(valid_attrs)
      assert deployment.name == "some name"
    end

    test "create_deployment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Databases.create_deployment(@invalid_attrs)
    end

    test "update_deployment/2 with valid data updates the deployment" do
      deployment = deployment_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Deployment{} = deployment} = Databases.update_deployment(deployment, update_attrs)
      assert deployment.name == "some updated name"
    end

    test "update_deployment/2 with invalid data returns error changeset" do
      deployment = deployment_fixture()
      assert {:error, %Ecto.Changeset{}} = Databases.update_deployment(deployment, @invalid_attrs)
      assert deployment == Databases.get_deployment!(deployment.id)
    end

    test "delete_deployment/1 deletes the deployment" do
      deployment = deployment_fixture()
      assert {:ok, %Deployment{}} = Databases.delete_deployment(deployment)
      assert_raise Ecto.NoResultsError, fn -> Databases.get_deployment!(deployment.id) end
    end

    test "change_deployment/1 returns a deployment changeset" do
      deployment = deployment_fixture()
      assert %Ecto.Changeset{} = Databases.change_deployment(deployment)
    end
  end

  describe "registrations" do
    alias Jellystone.Databases.Registration

    import Jellystone.DatabasesFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_registrations/0 returns all registrations" do
      registration = registration_fixture()
      assert Databases.list_registrations() == [registration]
    end

    test "get_registration!/1 returns the registration with given id" do
      registration = registration_fixture()
      assert Databases.get_registration!(registration.id) == registration
    end

    test "create_registration/1 with valid data creates a registration" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Registration{} = registration} = Databases.create_registration(valid_attrs)
      assert registration.description == "some description"
      assert registration.name == "some name"
    end

    test "create_registration/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Databases.create_registration(@invalid_attrs)
    end

    test "update_registration/2 with valid data updates the registration" do
      registration = registration_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Registration{} = registration} = Databases.update_registration(registration, update_attrs)
      assert registration.description == "some updated description"
      assert registration.name == "some updated name"
    end

    test "update_registration/2 with invalid data returns error changeset" do
      registration = registration_fixture()
      assert {:error, %Ecto.Changeset{}} = Databases.update_registration(registration, @invalid_attrs)
      assert registration == Databases.get_registration!(registration.id)
    end

    test "delete_registration/1 deletes the registration" do
      registration = registration_fixture()
      assert {:ok, %Registration{}} = Databases.delete_registration(registration)
      assert_raise Ecto.NoResultsError, fn -> Databases.get_registration!(registration.id) end
    end

    test "change_registration/1 returns a registration changeset" do
      registration = registration_fixture()
      assert %Ecto.Changeset{} = Databases.change_registration(registration)
    end
  end

  describe "tags" do
    alias Jellystone.Databases.Tag

    import Jellystone.DatabasesFixtures

    @invalid_attrs %{name: nil}

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Databases.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Databases.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Tag{} = tag} = Databases.create_tag(valid_attrs)
      assert tag.name == "some name"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Databases.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Tag{} = tag} = Databases.update_tag(tag, update_attrs)
      assert tag.name == "some updated name"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Databases.update_tag(tag, @invalid_attrs)
      assert tag == Databases.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Databases.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Databases.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Databases.change_tag(tag)
    end
  end

  describe "database_tags" do
    alias Jellystone.Databases.DatabaseTag

    import Jellystone.DatabasesFixtures

    @invalid_attrs %{}

    test "list_database_tags/0 returns all database_tags" do
      database_tag = database_tag_fixture()
      assert Databases.list_database_tags() == [database_tag]
    end

    test "get_database_tag!/1 returns the database_tag with given id" do
      database_tag = database_tag_fixture()
      assert Databases.get_database_tag!(database_tag.id) == database_tag
    end

    test "create_database_tag/1 with valid data creates a database_tag" do
      valid_attrs = %{}

      assert {:ok, %DatabaseTag{} = database_tag} = Databases.create_database_tag(valid_attrs)
    end

    test "create_database_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Databases.create_database_tag(@invalid_attrs)
    end

    test "update_database_tag/2 with valid data updates the database_tag" do
      database_tag = database_tag_fixture()
      update_attrs = %{}

      assert {:ok, %DatabaseTag{} = database_tag} = Databases.update_database_tag(database_tag, update_attrs)
    end

    test "update_database_tag/2 with invalid data returns error changeset" do
      database_tag = database_tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Databases.update_database_tag(database_tag, @invalid_attrs)
      assert database_tag == Databases.get_database_tag!(database_tag.id)
    end

    test "delete_database_tag/1 deletes the database_tag" do
      database_tag = database_tag_fixture()
      assert {:ok, %DatabaseTag{}} = Databases.delete_database_tag(database_tag)
      assert_raise Ecto.NoResultsError, fn -> Databases.get_database_tag!(database_tag.id) end
    end

    test "change_database_tag/1 returns a database_tag changeset" do
      database_tag = database_tag_fixture()
      assert %Ecto.Changeset{} = Databases.change_database_tag(database_tag)
    end
  end
end
