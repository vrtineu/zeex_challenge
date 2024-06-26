defmodule ZeexWeb.PartnerController do
  use ZeexWeb, :controller

  alias Zeex.Partners
  alias Zeex.Partners.Partner

  action_fallback ZeexWeb.FallbackController

  def index(conn, _params) do
    partners = Partners.list_partners()
    render(conn, :index, partners: partners)
  end

  def create(conn, _params_from_client) do
    partner_params = conn.private[:transformed_params] |> Map.get("partner")

    with {:ok, %Partner{} = partner} <- Partners.create_partner(partner_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/partners/#{partner}")
      |> render(:show, partner: partner)
    end
  end

  def show(conn, %{"id" => id}) do
    partner = Partners.get_partner!(id)
    render(conn, :show, partner: partner)
  end

  def update(conn, %{"id" => id, "partner" => partner_params}) do
    partner = Partners.get_partner!(id)

    with {:ok, %Partner{} = partner} <- Partners.update_partner(partner, partner_params) do
      render(conn, :show, partner: partner)
    end
  end

  def delete(conn, %{"id" => id}) do
    partner = Partners.get_partner!(id)

    with {:ok, %Partner{}} <- Partners.delete_partner(partner) do
      send_resp(conn, :no_content, "")
    end
  end

  def nearest(conn, %{"lat" => lat, "lng" => lng}) do
    partner = Partners.nearest_partner!(lat, lng)
    render(conn, :show, partner: partner)
  end
end
