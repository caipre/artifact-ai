defmodule ArtifactAiWeb.Router do
  use ArtifactAiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ArtifactAiWeb.Layouts, :root}
    plug :put_secure_browser_headers
  end

  pipeline :csrf do
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ArtifactAiWeb do
    pipe_through [:browser, :csrf]

    get "/", PageController, :home
    get "/login", PageController, :show_login
  end

  scope "/", ArtifactAiWeb do
    pipe_through [:browser]
    post "/login", PageController, :handle_login
  end

  # Other scopes may use custom stacks.
  # scope "/api", ArtifactAiWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:artifact_ai, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ArtifactAiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
