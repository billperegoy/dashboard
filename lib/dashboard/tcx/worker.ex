defmodule Dashboard.Tcx.Worker do
  use Oban.Worker, queue: :events

  alias Dashboard.Tcx

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"path" => path}}) do
    Tcx.import_from_zip(path)

    :ok
  end
end
