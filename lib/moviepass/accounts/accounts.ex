defmodule Moviepass.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Moviepass.Accounts.User
  alias Moviepass.Repo

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def list_users() do
    Repo.all(User)
  end

end
