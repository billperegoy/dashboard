defmodule Dashboard.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :started_at, :utc_datetime_usec, null: false
      add :notes, :string, null: false
      add :total_time_in_seconds, :integer, null: false
      add :distance_in_meters, :float, null: false
      add :total_calories, :float, null: false
      add :intensity, :string, null: false
      add :user_id, references(:users), null: false

      timestamps()
    end
  end
end
