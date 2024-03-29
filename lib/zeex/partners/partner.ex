defmodule Zeex.Partners.Partner do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "partners" do
    field :trading_name, :string
    field :owner_name, :string
    field :document, :string
    field :coverage_area, Geo.PostGIS.Geometry
    field :address, Geo.PostGIS.Geometry

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(partner, attrs) do
    partner
    |> cast(attrs, [:trading_name, :owner_name, :document, :coverage_area, :address])
    |> validate_required([:trading_name, :owner_name, :document, :coverage_area, :address])
  end
end
