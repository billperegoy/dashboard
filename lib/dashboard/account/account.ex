defmodule Dashboard.Account do
  alias Dashboard.Account.User
  alias Dashboard.Repo

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
