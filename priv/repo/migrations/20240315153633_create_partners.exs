defmodule Zeex.Repo.Migrations.CreatePartners do
  use Ecto.Migration

  def change do
    create table(:partners, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :trading_name, :string
      add :owner_name, :string
      add :document, :string

      timestamps(type: :utc_datetime)
    end
  end
end
