defmodule Dashboard.TcxTest do
  use Dashboard.DataCase

  import Dashboard.Factory
  alias Dashboard.Tcx

  describe "activity" do
    test "create with valid attributes" do
      user = insert(:user)

      attrs = %{
        distance_in_meters: 3001,
        intensity: "Active",
        notes: "activity notes",
        total_calories: 70,
        total_time_in_seconds: 600,
        user_id: user.id
      }

      {:ok, activity} = Tcx.create_activity(attrs)

      assert_maps_equal(activity, attrs, Tcx.Activity.attributes())
    end

    test "create with invalid attributes" do
      attrs = %{}

      {:error, %{errors: errors}} = Tcx.create_activity(attrs)

      expected_errors =
        Tcx.Activity.required_attrs()
        |> Enum.map(&{&1, {"can't be blank", [validation: :required]}})

      assert errors == expected_errors
    end

    test "list" do
      user = insert(:user)
      other_user = insert(:user)

      expected_activities =
        insert_list(3, :activity, user: user)
        |> Enum.sort_by(& &1.inserted_at, DateTime)

      _other_user_activities = insert_list(3, :activity, user: other_user)

      fetched_activities = Tcx.list_activities(user)

      assert_lists_equal(
        fetched_activities,
        expected_activities,
        &assert_structs_equal(&1, &2, [:id])
      )
    end
  end
end
