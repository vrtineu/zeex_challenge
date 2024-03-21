defmodule Zeex.StoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Zeex.Store` context.
  """

  @doc """
  Generate a partner.
  """
  def partner_fixture(attrs \\ %{}) do
    {:ok, address} = Geo.WKT.decode("POINT(30 -90)")
    {:ok, coverage_area} = Geo.WKT.decode("POLYGON((30 -90, 30 -89, 31 -89, 31 -90, 30 -90))")

    {:ok, partner} =
      attrs
      |> Enum.into(%{
        document: "some document",
        owner_name: "some owner_name",
        trading_name: "some trading_name",
        address: address,
        coverage_area: coverage_area
      })
      |> Zeex.Store.create_partner()

    partner
  end
end
