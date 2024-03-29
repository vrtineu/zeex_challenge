defmodule ZeexWeb.PartnerControllerTest do
  use ZeexWeb.ConnCase

  import Zeex.PartnersFixtures

  alias Zeex.Partners.Partner

  @create_attrs %{
    trading_name: "some trading_name",
    owner_name: "some owner_name",
    document: "some document",
    address: %{
      "coordinates" => [30, -90],
      "type" => "Point"
    },
    coverageArea: %{
      "coordinates" => [[[30, -90], [30, -89], [31, -89], [31, -90], [30, -90]]],
      "type" => "Polygon"
    }
  }
  @update_attrs %{
    trading_name: "some updated trading_name",
    owner_name: "some updated owner_name",
    document: "some updated document"
  }
  @invalid_attrs %{
    tradingName: nil,
    ownerName: nil,
    document: nil,
    address: nil,
    coverageArea: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all partners", %{conn: conn} do
      conn = get(conn, ~p"/api/partners")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create partner" do
    test "renders partner when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/partners", partner: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/partners/#{id}")

      assert %{
               "id" => ^id,
               "document" => "some document",
               "ownerName" => "some owner_name",
               "tradingName" => "some trading_name",
               "address" => %{"coordinates" => [30.0, -90.0], "type" => "Point"},
               "coverageArea" => %{
                 "coordinates" => [
                   [[30.0, -90.0], [30.0, -89.0], [31.0, -89.0], [31.0, -90.0], [30.0, -90.0]]
                 ],
                 "type" => "Polygon"
               }
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/partners", partner: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update partner" do
    setup [:create_partner]

    test "renders partner when data is valid", %{conn: conn, partner: %Partner{id: id} = partner} do
      conn = put(conn, ~p"/api/partners/#{partner}", partner: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/partners/#{id}")

      assert %{
               "id" => ^id,
               "document" => "some updated document",
               "ownerName" => "some updated owner_name",
               "tradingName" => "some updated trading_name",
               "address" => %{"coordinates" => [30.0, -90.0], "type" => "Point"},
               "coverageArea" => %{
                 "coordinates" => [
                   [[30.0, -90.0], [30.0, -89.0], [31.0, -89.0], [31.0, -90.0], [30.0, -90.0]]
                 ],
                 "type" => "Polygon"
               }
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, partner: partner} do
      conn = put(conn, ~p"/api/partners/#{partner}", partner: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete partner" do
    setup [:create_partner]

    test "deletes chosen partner", %{conn: conn, partner: partner} do
      conn = delete(conn, ~p"/api/partners/#{partner}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/partners/#{partner}")
      end
    end
  end

  describe "find nearest partner" do
    setup [:create_partner]

    test "finds nearest partner", %{conn: conn, partner: %Partner{id: id}} do
      conn = get(conn, ~p"/api/partners/nearest?lat=-89.5&lng=30.1")

      assert %{
               "id" => ^id,
               "document" => "some document",
               "ownerName" => "some owner_name",
               "tradingName" => "some trading_name",
               "address" => %{"coordinates" => [30.0, -90.0], "type" => "Point"},
               "coverageArea" => %{
                 "coordinates" => [
                   [[30.0, -90.0], [30.0, -89.0], [31.0, -89.0], [31.0, -90.0], [30.0, -90.0]]
                 ],
                 "type" => "Polygon"
               }
             } = json_response(conn, 200)["data"]
    end
  end

  defp create_partner(_) do
    partner = partner_fixture()
    %{partner: partner}
  end
end
