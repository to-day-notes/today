defmodule TodayWeb.PageController do
  use TodayWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
