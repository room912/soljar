defmodule SoljarWeb.RedirectController do
  use SoljarWeb, :controller

  import SoljarWeb.UserAuth, only: [fetch_current_user: 2]

  plug :fetch_current_user

  def redirect_authenticated(conn, _) do
    if conn.assigns.current_user do
      SoljarWeb.UserAuth.redirect_if_user_is_authenticated(conn, [])
    else
      redirect(conn, to: ~p"/login")
    end
  end
end
