defmodule Moviepass.Repo.Migrations.AddTokenToCredentials do
  use Ecto.Migration

  def change do
    alter table(:credentials) do
      add :token, :string
    end
  end
end
