# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Dashboard.Repo.insert!(%Dashboard.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
user = Dashboard.Repo.insert!(%Dashboard.Account.User{username: "user-1"})

# Dashboard.Repo.insert!(%Dashboard.Tcx.Activity{
#  started_at: DateTime.utc_now(),
#  distance_in_meters: 3000.0,
#  intensity: "Active",
#  notes: "activity notes",
#  total_calories: 70.0,
#  total_time_in_seconds: 600,
#  user_id: user.id
# })
#
# Dashboard.Repo.insert!(%Dashboard.Tcx.Activity{
#  started_at: DateTime.utc_now(),
#  distance_in_meters: 6000.0,
#  intensity: "Active",
#  notes: "activity notes",
#  total_calories: 120.0,
#  total_time_in_seconds: 800,
#  user_id: user.id
# })
