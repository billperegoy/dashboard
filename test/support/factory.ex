defmodule Dashboard.Factory do
  use ExMachina.Ecto, repo: Dashboard.Repo

  alias Dashboard.{Account, Tcx}

  def activity_factory do
    %Tcx.Activity{
      notes: "Notes for this activity",
      intensity: "Active",
      total_time_in_seconds: 600,
      distance_in_meters: 3500,
      total_calories: 80,
      user: build(:user)
    }
  end

  def user_factory do
    %Account.User{
      username: sequence(:username, &"user-#{&1}")
    }
  end
end
