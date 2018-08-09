defmodule MoviepassWeb.Router do
  use MoviepassWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MoviepassWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MoviepassWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", MoviepassWeb do
  #   pipe_through :api
  # end
end
