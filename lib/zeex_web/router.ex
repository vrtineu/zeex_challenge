defmodule ZeexWeb.Router do
  use ZeexWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ZeexWeb do
    pipe_through :api

    get "/partners/nearest", PartnerController, :nearest
    resources "/partners", PartnerController, except: [:new, :edit]
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:zeex, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ZeexWeb.Telemetry
    end
  end
end
