defmodule HelloPhoenix.PageController do
  use HelloPhoenix.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def index_with_error(conn, _params) do
    conn
    |> put_flash(:info, "Welcome to Phoenix, from flash info!")
    |> put_flash(:error, "Let's pretend we have an error.")
    |> render("index.html")
  end

  def index_with_params(conn, %{"name" => dangerously_injected_name}) do
    render conn, "index_with_params.html", name: dangerously_injected_name
  end
























  # ecto

  def keyword_query do
    query = from w in Weather,
         where: w.rainfall > 0 or is_nil(w.rainfall),
         select: w
    Repo.all(query)
  end

  def pipe_query do
    Weather
    |> where(city: "Kraków")
    |> order_by(:temperature)
    |> limit(10)
    |> Repo.all
  end

end
