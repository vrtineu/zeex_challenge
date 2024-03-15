defmodule ZeexWeb.PartnerJSON do
  alias Zeex.Store.Partner

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
      trading_name: partner.trading_name,
      owner_name: partner.owner_name,
      document: partner.document
    }
  end
end
