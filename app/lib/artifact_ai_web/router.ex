defmodule ArtifactAiWeb.Router do
  use ArtifactAiWeb, :router

  import ArtifactAiWeb.Plugs.Auth
  alias ArtifactAiWeb.Plugs

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ArtifactAiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :unsafe do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ArtifactAiWeb.Layouts, :root}
    plug :put_secure_browser_headers
  end

  scope "/", ArtifactAiWeb do
    pipe_through [:unsafe]
    get "/welcome", PageController, :welcome
    post "/auth/sign_in", AuthController, :maybe_sign_in
  end

  scope "/", ArtifactAiWeb do
    pipe_through :browser
    get "/about", PageController, :about
  end

  scope "/", ArtifactAiWeb do
    pipe_through [:browser, :assign_current_user, :authenticated]
    post "/auth/sign_out", AuthController, :sign_out
  end

  ## Live Routes

  scope "/", ArtifactAiWeb do
    pipe_through [:browser, :assign_current_user, :authenticated]

    live_session :main, on_mount: [{Plugs.Auth, :mount_current_user}] do
      live "/", CreateLive.Index

      live "/e/:prompt/:image", CreateLive.Show

      live "/orders/:id/review", OrderLive.Review
      live "/orders/:id/payment", OrderLive.Payment
      live "/orders/:id/success", OrderLive.Success
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:artifact_ai, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:browser]

      live_dashboard "/dashboard", metrics: ArtifactAiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
