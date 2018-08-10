defmodule MoviepassWeb.OauthController do
  use MoviepassWeb, :controller
  alias MoviepassWeb.Oauth.LearnClient
  alias MoviepassWeb.Auth

  def index(conn, _params) do
    render conn, "index.html"
  end

  def new(conn, _params) do
    redirect_url = LearnClient.redirect_url()
    redirect(conn, external: redirect_url)
  end

  def create(conn, params) do
    {:ok, response} = LearnClient.get_token_response(params)

    case response.status_code do
      status_code when status_code > 399 ->
        conn
        |> put_flash(:warn, "There was an error logging you in")
        |> redirect(to: "/")
      _ ->
        %{"access_token" => access_token} = Jason.decode!(response.body)

      conn
      |> Auth.login_with_token(access_token)
      |> redirect(to: Routes.oauth_path(conn, :index))
    end
  end
end
