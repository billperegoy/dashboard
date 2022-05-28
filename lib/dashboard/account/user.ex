defmodule Dashboard.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime_usec]

  schema "users" do
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, required_attrs())
    |> validate_required(required_attrs())
  end

  def required_attrs do
    [:username]
  end

  defp optional_attrs do
    []
  end

  def attributes do
    required_attrs() ++ optional_attrs()
  end
end
