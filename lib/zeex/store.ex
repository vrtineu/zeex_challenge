defmodule Zeex.Store do
  @moduledoc """
  The Store context.
  """

  import Ecto.Query, warn: false
  import Geo.PostGIS

  alias Zeex.Repo
  alias Zeex.Store.Partner

  @doc """
  Returns the list of partners.

  ## Examples

      iex> list_partners()
      [%Partner{}, ...]

  """
  def list_partners do
    Repo.all(Partner)
  end

  @doc """
  Gets a single partner.

  Raises `Ecto.NoResultsError` if the Partner does not exist.

  ## Examples

      iex> get_partner!(123)
      %Partner{}

      iex> get_partner!(456)
      ** (Ecto.NoResultsError)

  """
  def get_partner!(id), do: Repo.get!(Partner, id)

  @doc """
  Creates a partner.

  ## Examples

      iex> create_partner(%{field: value})
      {:ok, %Partner{}}

      iex> create_partner(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_partner(attrs \\ %{}) do
    %Partner{}
    |> Partner.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a partner.

  ## Examples

      iex> update_partner(partner, %{field: new_value})
      {:ok, %Partner{}}

      iex> update_partner(partner, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_partner(%Partner{} = partner, attrs) do
    partner
    |> Partner.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a partner.

  ## Examples

      iex> delete_partner(partner)
      {:ok, %Partner{}}

      iex> delete_partner(partner)
      {:error, %Ecto.Changeset{}}

  """
  def delete_partner(%Partner{} = partner) do
    Repo.delete(partner)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking partner changes.

  ## Examples

      iex> change_partner(partner)
      %Ecto.Changeset{data: %Partner{}}

  """
  def change_partner(%Partner{} = partner, attrs \\ %{}) do
    Partner.changeset(partner, attrs)
  end

  defp is_valid_geo?(geo) do
    is_map(geo) && Map.has_key?(geo, "type") && is_bitstring(Map.get(geo, "type")) &&
      Map.has_key?(geo, "coordinates") && is_list(Map.get(geo, "coordinates"))
  end

  @doc """
  Decodes a GeoJSON object.

  ## Examples

      iex> decode_geo(%{"type" => "Point", "coordinates" => [1, 2]})
      {:ok, %Geo.Point{}}

      iex> decode_geo(%{"type" => "MultiPolygon", "coordinates" => [[[1, 2], [3, 4]]]})
      {:ok, %Geo.MultiPolygon{}}

      iex> decode_geo(%{"type" => "Point", "coordinates" => "invalid"})
      {:error, :invalid_geo}

  """
  def decode_geo(geo) do
    if is_valid_geo?(geo) do
      Geo.JSON.decode(geo)
    else
      {:error, :invalid_geo}
    end
  end

  @doc """
  Returns the nearest partner to a given point.

  ## Examples

      iex> nearest_partner!(1, 2)
      %Partner{}

      iex> nearest_partner!(3, 4)
      ** (Ecto.NoResultsError)

  """
  def nearest_partner!(lat, lng) do
    {float_lat, _} = Float.parse(lat)
    {float_lng, _} = Float.parse(lng)

    point = %Geo.Point{coordinates: {float_lng, float_lat}}

    stores_containing_point =
      from(
        p in Partner,
        where: st_contains(p.coverage_area, ^point),
        select: %{id: p.id, st_distance: st_distance(p.address, ^point)}
      )

    nearest_store =
      from(
        p in Partner,
        join: store in subquery(stores_containing_point),
        on: p.id == store.id,
        order_by: [asc: store.st_distance],
        limit: 1,
        select: p
      )

    Repo.one!(nearest_store)
  end
end
