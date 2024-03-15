defmodule Zeex.StoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Zeex.Store` context.
  """

  @doc """
  Generate a partner.
  """
  def partner_fixture(attrs \\ %{}) do
    {:ok, partner} =
      attrs
      |> Enum.into(%{
        document: "some document",
        owner_name: "some owner_name",
        trading_name: "some trading_name"
      })
      |> Zeex.Store.create_partner()

    partner
  end
end
