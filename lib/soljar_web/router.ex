defmodule SoljarWeb.Router do
  use SoljarWeb, :router

  import SoljarWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SoljarWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SoljarWeb do
    pipe_through :browser

    get "/", RedirectController, :redirect_authenticated
    live "/jars/:uri", JarLive.Show, :show
    live "/jars/:uri/error", JarLive.Show, :error
    live "/jars/:uri/success", JarLive.Show, :success
    live "/jars/:uri/qr", JarLive.Show, :qr

  end

  # Other scopes may use custom stacks.
  # scope "/api", SoljarWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:soljar, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SoljarWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", SoljarWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      layout: {SoljarWeb.Layouts, :guest},
      on_mount: [{SoljarWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/log_in", UserLoginLive, :new
      live "/login", HomeLive
      live "/help", HelpLive
      live "/demo", DemoLive
      live "/pitch_deck", PitchDeckLive
      live "/contact", ContactLive
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", SoljarWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user, layout: {SoljarWeb.Layouts, :dashboard}, on_mount: [{SoljarWeb.UserAuth, :ensure_authenticated}] do
        live "/dashboard", DashboardLive, :page
        live "/settings", SettingsLive, :page
        live "/dashboard/jars/new", DashboardLive, :new
        live "/dashboard/jars/:id/edit", DashboardLive, :edit
    end
  end

  scope "/", SoljarWeb do
    pipe_through [:browser]

    post "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{SoljarWeb.UserAuth, :mount_current_user}] do
    end
  end
end
