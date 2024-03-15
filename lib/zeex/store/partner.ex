defmodule Zeex.Store.Partner do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "partners" do
    field :trading_name, :string
    field :owner_name, :string
    field :document, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(partner, attrs) do
    partner
    |> cast(attrs, [:trading_name, :owner_name, :document])
    |> validate_required([:trading_name, :owner_name, :document])
  end
end
