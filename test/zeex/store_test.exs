defmodule Zeex.StoreTest do
  use Zeex.DataCase

  alias Zeex.Store

  describe "partners" do
    alias Zeex.Store.Partner

    import Zeex.StoreFixtures

    @invalid_attrs %{trading_name: nil, owner_name: nil, document: nil}

    test "list_partners/0 returns all partners" do
      partner = partner_fixture()
      assert Store.list_partners() == [partner]
    end

    test "get_partner!/1 returns the partner with given id" do
      partner = partner_fixture()
      assert Store.get_partner!(partner.id) == partner
    end

    test "create_partner/1 with valid data creates a partner" do
      valid_attrs = %{
        trading_name: "some trading_name",
        owner_name: "some owner_name",
        document: "some document",
        address: Geo.WKT.decode("POINT(30 -90)"),
        coverage_area: Geo.WKT.decode("POLYGON((30 -90, 30 -89, 31 -89, 31 -90, 30 -90))")
      }

      assert {:ok, %Partner{} = partner} = Store.create_partner(valid_attrs)
      assert partner.trading_name == "some trading_name"
      assert partner.owner_name == "some owner_name"
      assert partner.document == "some document"
    end

    test "create_partner/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_partner(@invalid_attrs)
    end

    test "update_partner/2 with valid data updates the partner" do
      partner = partner_fixture()

      update_attrs = %{
        trading_name: "some updated trading_name",
        owner_name: "some updated owner_name",
        document: "some updated document"
      }

      assert {:ok, %Partner{} = partner} = Store.update_partner(partner, update_attrs)
      assert partner.trading_name == "some updated trading_name"
      assert partner.owner_name == "some updated owner_name"
      assert partner.document == "some updated document"
    end

    test "update_partner/2 with invalid data returns error changeset" do
      partner = partner_fixture()
      assert {:error, %Ecto.Changeset{}} = Store.update_partner(partner, @invalid_attrs)
      assert partner == Store.get_partner!(partner.id)
    end

    test "delete_partner/1 deletes the partner" do
      partner = partner_fixture()
      assert {:ok, %Partner{}} = Store.delete_partner(partner)
      assert_raise Ecto.NoResultsError, fn -> Store.get_partner!(partner.id) end
    end

    test "change_partner/1 returns a partner changeset" do
      partner = partner_fixture()
      assert %Ecto.Changeset{} = Store.change_partner(partner)
    end

    test "decode_geo/1 returns :ok with valid geo" do
      geo = %{
        "type" => "Point",
        "coordinates" => [30, -90]
      }

      assert {:ok, _} = Store.decode_geo(geo)
    end

    test "decode_geo/1 returns :error with invalid geo" do
      geo = %{
        "type" => "Point",
        "coordinates" => "invalid"
      }

      assert {:error, :invalid_geo} = Store.decode_geo(geo)
    end
  end
end
