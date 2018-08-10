# Thanks Team Hot Sauce
defmodule MoviepassWeb.Oauth.LearnClient do
  @learn_client_id "5e6b6aca3ab5a3f3e3ab23ed5d749bc2d3abbd1da24dc239d9fa9985ff177fd5"
  @learn_client_secret "f9524f0f1ddc42c6bf2394e1ff473825eb975dab44ccdf5031047fcc54a5603f"
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
