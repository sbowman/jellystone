defmodule Jellystone.Accounts.TeamMember do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jellystone.Accounts

  schema "team_members" do
    belongs_to :team, Accounts.Team
    belongs_to :user, Accounts.User

    timestamps()
  end

  @doc false
  def changeset(team_member, attrs) do
    team_member
    |> cast(attrs, [:team, :user])
    |> validate_required([:team, :user])
  end
end
