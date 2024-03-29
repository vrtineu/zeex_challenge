defmodule ZeexWeb.PartnerJSON do
  alias Zeex.Partners.Partner

  @doc """
  Renders a list of partners.
  """
  def index(%{partners: partners}) do
    %{data: for(partner <- partners, do: data(partner))}
  end

  @doc """
  Renders a single partner.
  """
  def show(%{partner: partner}) do
    %{data: data(partner)}
  end

  defp data(%Partner{} = partner) do
    %{
      id: partner.id,
      tradingName: partner.trading_name,
      ownerName: partner.owner_name,
      document: partner.document,
      address: partner.address,
      coverageArea: partner.coverage_area
    }
  end
end
