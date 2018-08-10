defmodule Moviepass.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  schema "credentials" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :token, :string
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
    |> put_pass_hash()
  end

  def token_changeset(credential, attrs) do
    credential
    |> cast(attrs, [:token])
  end

  def put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  def validate_strength(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, value ->
      case Regex.match?(~r/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/, value) do
        true -> []
        false -> [{field, options[:message] || "Must be at least 8 characters long and include a number"}]
      end
    end)
  end
end
