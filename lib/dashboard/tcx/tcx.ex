defmodule Dashboard.Tcx do
  import Ecto.Query

  import SweetXml

  alias Dashboard.Repo
  alias Dashboard.Tcx.Activity
  alias Dashboard.Account.User

  def create_activity(attrs) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end

  def list_activities(user) do
    from(activity in Activity, where: activity.user_id == ^user.id, order_by: activity.started_at)
    |> Repo.all()
  end

  def import_all do
    dir = "/Users/bill/iFit/iFitWorkouts_2022_02_01_to_2022_05_02_8af7b7c9"

    {:ok, files} = File.ls(dir)

    files
    |> Enum.each(fn file ->
      path = dir <> "/" <> file

      {:ok, _} = parse_one(path)
    end)
  end

  def parse_one(path) do
    {:ok, doc} = File.read(path)

    result =
      doc
      |> xpath(~x"//Activities/Activity"l,
        id: ~x"./Id/text()",
        notes: ~x"./Notes/text()",
        start_time: ~x"./Lap/StartTime/text()",
        total_time_in_seconds: ~x"./Lap/TotalTimeSeconds/text()",
        distance_in_meters: ~x"./Lap/DistanceMeters/text()",
        total_calories: ~x"./Lap/Calories/text()",
        intensity: ~x"./Lap/Intensity/text()",
        distance_list: ~x"./Lap/Track/Trackpoint/DistanceMeters/text()"l,
        cadence_list: ~x"./Lap/Track/Trackpoint/Cadence/text()"l,
        calories_list: ~x"./Lap/Track/Trackpoint/Calories/text()"l,
        time_list: ~x"./Lap/Track/Trackpoint/Time/text()"l,
        altitude_list: ~x"./Lap/Track/Trackpoint/AltitudeMeters/text()"l
      )

    if Enum.count(result) == 1 do
      activity = Enum.at(result, 0)

      {total_time_in_seconds, ""} = Integer.parse(to_string(activity.total_time_in_seconds))
      {total_calories, ""} = Float.parse(to_string(activity.total_calories))
      {distance_in_meters, ""} = Float.parse(to_string(activity.distance_in_meters))

      _trackpoints =
        activity.distance_list
        |> Enum.zip(activity.cadence_list)
        |> Enum.zip(activity.calories_list)
        |> Enum.zip(activity.time_list)
        |> Enum.zip(activity.altitude_list)
        |> Enum.map(&flatten_tuple/1)
        |> Enum.map(
          &%{
            distance: elem(&1, 0),
            cadence: elem(&1, 1),
            calories: elem(&1, 2),
            time: elem(&1, 3),
            altitude: elem(&1, 4)
          }
        )

      user = Repo.one(User)

      attrs = %{
        started_at: to_datetime(activity.id),
        intensity: to_string(activity.intensity),
        notes: to_string(activity.notes),
        total_time_in_seconds: total_time_in_seconds,
        total_calories: total_calories,
        distance_in_meters: distance_in_meters,
        user_id: user.id
        # trackpoints: trackpoints
        # trackpoints: []
      }

      create_activity(attrs)
    else
      {:error, "Expected one activity per tcx file"}
    end
  end

  defp to_datetime(x) do
    {:ok, datetime, _} =
      x
      |> to_string()
      |> DateTime.from_iso8601()

    datetime
  end

  defp flatten_tuple({{{{a, b}, c}, d}, e}) do
    {a, ""} = Integer.parse(to_string(a))
    {b, ""} = Float.parse(to_string(b))
    {c, ""} = Float.parse(to_string(c))
    {:ok, d, 0} = DateTime.from_iso8601(to_string(d))
    {e, ""} = Float.parse(to_string(e))
    {a, b, c, d, e}
  end
end
