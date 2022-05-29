defmodule DashboardWeb.UploadController do
  use DashboardWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"upload" => %Plug.Upload{} = %{filename: filename, path: tmp_path}}) do
    uploads_dir = Application.get_env(:dashboard, :uploads_directory)
    upload_path = uploads_dir <> "/" <> filename
    :ok = File.cp(tmp_path, upload_path)

    %{"path" => upload_path}
    |> Dashboard.Tcx.Worker.new(queue: :default)
    |> Oban.insert()

    redirect(conn, to: "/")
  end
end
