Team Hot Sauce
defmodule MoviepassWeb.Oauth.LearnClient do
  @learn_client_id "SUPER SECRET CLIENT ID"
  @learn_client_secret "SUPER SECRET SECRET"
  @host_base_url "http://localhost:4000"
  @redirect_uri "#{@host_base_url}/oauth/learn/callback"
  @learn_url "https://learn.co"
  @learn_auth_endpoint "/oauth/authorize"
  @learn_token_endpoint "/oauth/token"

  def client do
    OAuth2.Client.new([
      client_id: @learn_client_id,
      client_secret: @learn_client_secret,
      redirect_uri: @redirect_uri,
      authorize_url: "#{@learn_url}#{@learn_auth_endpoint}",
      token_url: "#{@learn_url}#{@learn_token_endpoint}"
    ])
  end

  def redirect_url do
    OAuth2.Client.authorize_url!(client())
  end

  def get_token_response(%{"code" => code }) do
    body = {:form, [
      {:client_id, @learn_client_id},
      {:client_secret, @learn_client_secret},
      {:grant_type, "authorization_code"},
      {:code, code},
      {:redirect_uri, @redirect_uri}
    ]}
    HTTPoison.post("#{@learn_url}#{@learn_token_endpoint}", body)
  end
end
