defmodule JellystoneWeb.Router do
  use JellystoneWeb, :router

  import JellystoneWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {JellystoneWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JellystoneWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  scope "/api", JellystoneWeb do
    pipe_through :api
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:jellystone, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: JellystoneWeb.Telemetry, ecto_repos: [Jellystone.Repo]
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", JellystoneWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{JellystoneWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", JellystoneWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{JellystoneWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      # Manage teams
      live "/teams", TeamLive.Index, :index
      live "/teams/new", TeamLive.Index, :new
      live "/teams/:id/edit", TeamLive.Index, :edit

      live "/teams/:id", TeamLive.Show, :show
      live "/teams/:id/show/edit", TeamLive.Show, :edit

      # Kubernetes sites
      live "/sites", SiteLive.Index, :index
      live "/sites/new", SiteLive.Index, :new
      live "/sites/:id/edit", SiteLive.Index, :edit

      live "/sites/:id", SiteLive.Show, :show
      live "/sites/:id/show/edit", SiteLive.Show, :edit
      live "/sites/:id/namespace/new", SiteLive.Show, :new_namespace
      live "/sites/:id/namespace/:nsid/edit", SiteLive.Show, :edit_namespace

      # Kubernetes namespaces
      live "/namespaces", NamespaceLive.Index, :index
      #       live "/namespaces/new", NamespaceLive.Index, :new
      #       live "/namespaces/:id/edit", NamespaceLive.Index, :edit
      # 
      live "/namespaces/:id", NamespaceLive.Show, :show
      #       live "/namespaces/:id/show/edit", NamespaceLive.Show, :edit

      # Kubernetes deployments, e.g. "fourier-core" or "delphi-core"
      live "/deployments", DeploymentLive.Index, :index
      live "/deployments/new", DeploymentLive.Index, :new
      live "/deployments/:id/edit", DeploymentLive.Index, :edit

      live "/deployments/:id", DeploymentLive.Show, :show
      live "/deployments/:id/show/edit", DeploymentLive.Show, :edit

      # Database registration (helps track the databases we've created)
      live "/registrations", RegistrationLive.Index, :index
      live "/registrations/new", RegistrationLive.Index, :new
      live "/registrations/:id/edit", RegistrationLive.Index, :edit

      live "/registrations/:id", RegistrationLive.Show, :show
      live "/registrations/:id/show/edit", RegistrationLive.Show, :edit

      # Support tagging databases
      live "/tags", TagLive.Index, :index
      live "/tags/new", TagLive.Index, :new
      live "/tags/:id/edit", TagLive.Index, :edit

      live "/tags/:id", TagLive.Show, :show
      live "/tags/:id/show/edit", TagLive.Show, :edit
    end
  end

  scope "/", JellystoneWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{JellystoneWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
