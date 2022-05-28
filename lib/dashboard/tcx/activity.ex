defmodule Dashboard.Tcx.Activity do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime_usec]

  alias Dashboard.Account

  schema "activities" do
    field :started_at, :utc_datetime_usec
    field :distance_in_meters, :float
    field :intensity, :string
    field :notes, :string
    field :total_calories, :float
    field :total_time_in_seconds, :integer

    belongs_to :user, Account.User

    timestamps()
  end

  @doc false
  def changeset(tcx, attrs) do
    tcx
    |> cast(attrs, required_attrs())
    |> validate_required(required_attrs())
  end

  def required_attrs do
    [
      :distance_in_meters,
      :intensity,
      :notes,
      :started_at,
      :total_calories,
      :total_time_in_seconds,
      :user_id
    ]
  end

  defp optional_attrs do
    []
  end

  def attributes do
    required_attrs() ++ optional_attrs()
  end
end
