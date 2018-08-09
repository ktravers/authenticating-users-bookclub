defmodule Moviepass.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  schema "credentials" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    belongs_to :user, Moviepass.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> validate_strength(:password)
  end

  def validate_strength(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _ ->
      case Regex.match?(~r/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/, field) do
        true -> []
        false -> [{field, options[:message] || "Unexpected URL"}]
      end
    end)
  end
end
