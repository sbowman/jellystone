defmodule Jellystone.Accounts.Team do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jellystone.Accounts

  schema "teams" do
    field :name, :string
    # , redact: true
    field :token, :string, virtual: true
    # , redact: true
    field :hashed_token, :string

    has_many :team_members, Accounts.TeamMember
    many_to_many :members, Accounts.User, join_through: Accounts.TeamMember

    timestamps()
  end

  @doc false
  def create_changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :token])
    |> validate_name()
    |> validate_token()
  end

  def rename_changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_name()
  end

  def token_changeset(team, attrs) do
    team
    |> cast(attrs, [:token])
    |> validate_confirmation(:token, message: "does not match token")
    |> validate_token()
  end

  defp validate_name(changeset) do
    changeset
    |> validate_required([:name])
    |> validate_length(:name, min: 4, max: 64)
    |> unsafe_validate_unique(:name, Jellystone.Repo)
  end

  defp validate_token(changeset) do
    changeset
    |> validate_required([:token])
    |> validate_length(:token, min: 4, max: 64)
    |> hash_token()
  end

  defp hash_token(changeset) do
    token = get_change(changeset, :token)

    if token && changeset.valid? do
      changeset
      |> put_change(:hashed_token, Argon2.hash_pwd_salt(token))
      |> delete_change(:token)
    else
      changeset
    end
  end
end
