defmodule DemoWeb.PageController do
  use DemoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, _params) do
    render(conn, "show.html", variable: "Hello I'm visible now!")
  end
end
