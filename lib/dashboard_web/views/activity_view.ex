defmodule DashboardWeb.ActivityView do
  use DashboardWeb, :view

  @timezone "America/New_York"
  def format_distance(distance_in_meters) do
    Float.round(distance_in_meters * 0.000621371, 2)
  end

  def format_duration(seconds) do
    Time.from_seconds_after_midnight(seconds)
  end

  def format_date(datetime_utc) do
    timezone = Timex.Timezone.get(@timezone)

    Timex.Timezone.convert(datetime_utc, timezone)
    |> DateTime.to_date()
  end
end
