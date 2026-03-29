defmodule PhoenixChatWeb.Router do
  use PhoenixChatWeb, :router

  import PhoenixChatWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhoenixChatWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Public temp room routes (no auth required)
  scope "/", PhoenixChatWeb do
    pipe_through :browser

    live_session :public,
      on_mount: [{PhoenixChatWeb.UserAuth, :mount_current_user}] do
      live "/temp", TempRoomLive.Index, :index
      live "/temp/new", TempRoomLive.Index, :new
      live "/temp/:slug", TempRoomLive.Show, :show
    end
  end

  # Auth routes
  scope "/", PhoenixChatWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{PhoenixChatWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", PhoenixChatWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{PhoenixChatWeb.UserAuth, :ensure_authenticated}] do
      live "/", RoomLive.Index, :index
      live "/rooms", RoomLive.Index, :index
      live "/rooms/new", RoomLive.Index, :new
      live "/rooms/:id", RoomLive.Show, :show
      live "/rooms/:id/edit", RoomLive.Index, :edit
      live "/rooms/:id/permit", RoomLive.Permit, :edit
    end
  end

  scope "/", PhoenixChatWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:phoenix_chat, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: PhoenixChatWeb.Telemetry
    end
  end
end
