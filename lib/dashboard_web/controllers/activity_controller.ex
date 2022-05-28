defmodule DashboardWeb.ActivityController do
  use DashboardWeb, :controller

  def index(conn, _params) do
    user = Dashboard.Repo.one(Dashboard.Account.User)
    activities = Dashboard.Tcx.list_activities(user)
    render(conn, "index.html", activities: activities)
  end
end
