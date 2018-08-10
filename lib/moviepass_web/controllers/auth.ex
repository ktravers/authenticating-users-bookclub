defmodule MoviepassWeb.Auth do
  import Plug.Conn

  alias Moviepass.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Accounts.get_user(user_id)
    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def login_by_email_and_pass(conn, email, pass) do
    case Accounts.authenticate_by_email_and_pass(email, pass) do
      {:ok, user} -> {:ok, login(conn, user)}
      {:error, :unauthorized} -> {:error, :unauthorized, conn}
      {:error, :not_found} -> {:error, :not_found, conn}
    end
  end

  def login_with_token(conn, token) do
    user = Accounts.get_user_by_token(token)
    case user do
      user -> {:ok, login(conn, user)}
      true -> Accounts.create_user_from_token(%{token: token})
    end
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end
end
