defmodule ZeexWeb.PartnerController do
  use ZeexWeb, :controller

  alias Zeex.Store
  alias Zeex.Store.Partner

  action_fallback ZeexWeb.FallbackController

  def index(conn, _params) do
    partners = Store.list_partners()
    render(conn, :index, partners: partners)
  end

  def create(conn, %{"partner" => partner_params}) do
    with {:ok, %Partner{} = partner} <- Store.create_partner(partner_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/partners/#{partner}")
      |> render(:show, partner: partner)
    end
  end

  def show(conn, %{"id" => id}) do
    partner = Store.get_partner!(id)
    render(conn, :show, partner: partner)
  end

  def update(conn, %{"id" => id, "partner" => partner_params}) do
    partner = Store.get_partner!(id)

    with {:ok, %Partner{} = partner} <- Store.update_partner(partner, partner_params) do
      render(conn, :show, partner: partner)
    end
  end

  def delete(conn, %{"id" => id}) do
    partner = Store.get_partner!(id)

    with {:ok, %Partner{}} <- Store.delete_partner(partner) do
      send_resp(conn, :no_content, "")
    end
  end
end
