defmodule Zeex.PartnersTest do
  use Zeex.DataCase

  alias Zeex.Partners

  describe "partners" do
    alias Zeex.Partners.Partner

    import Zeex.PartnersFixtures

    @invalid_attrs %{trading_name: nil, owner_name: nil, document: nil}

    test "list_partners/0 returns all partners" do
      partner = partner_fixture()
      assert Partners.list_partners() == [partner]
    end

    test "get_partner!/1 returns the partner with given id" do
      partner = partner_fixture()
      assert Partners.get_partner!(partner.id) == partner
    end

    test "create_partner/1 with valid data creates a partner" do
      valid_attrs = %{
        trading_name: "some trading_name",
        owner_name: "some owner_name",
        document: "some document",
        address: %{
          "type" => "Point",
          "coordinates" => [30, -90]
        },
        coverage_area: %{
          "type" => "Polygon",
          "coordinates" => [[[30, -90], [30, -89], [31, -89], [31, -90], [30, -90]]]
        }
      }

      assert {:ok, %Partner{} = partner} = Partners.create_partner(valid_attrs)
      assert partner.trading_name == "some trading_name"
      assert partner.owner_name == "some owner_name"
      assert partner.document == "some document"
    end

    test "create_partner/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Partners.create_partner(@invalid_attrs)
    end

    test "update_partner/2 with valid data updates the partner" do
      partner = partner_fixture()

      update_attrs = %{
        trading_name: "some updated trading_name",
        owner_name: "some updated owner_name",
        document: "some updated document",
        address: %{
          "type" => "Point",
          "coordinates" => [30, -90]
        },
        coverage_area: %{
          "type" => "Polygon",
          "coordinates" => [[[30, -90], [30, -89], [31, -89], [31, -90], [30, -90]]]
        }
      }

      assert {:ok, %Partner{} = partner} = Partners.update_partner(partner, update_attrs)
      assert partner.trading_name == "some updated trading_name"
      assert partner.owner_name == "some updated owner_name"
      assert partner.document == "some updated document"
      assert partner.address == %Geo.Point{coordinates: {30, -90}, properties: %{}, srid: nil}

      assert partner.coverage_area == %Geo.Polygon{
               coordinates: [[{30, -90}, {30, -89}, {31, -89}, {31, -90}, {30, -90}]],
               srid: nil,
               properties: %{}
             }
    end

    test "update_partner/2 with invalid data returns error changeset" do
      partner = partner_fixture()
      assert {:error, %Ecto.Changeset{}} = Partners.update_partner(partner, @invalid_attrs)
      assert partner == Partners.get_partner!(partner.id)
    end

    test "delete_partner/1 deletes the partner" do
      partner = partner_fixture()
      assert {:ok, %Partner{}} = Partners.delete_partner(partner)
      assert_raise Ecto.NoResultsError, fn -> Partners.get_partner!(partner.id) end
    end

    test "change_partner/1 returns a partner changeset" do
      partner = partner_fixture()
      assert %Ecto.Changeset{} = Partners.change_partner(partner)
    end

    test "decode_geo/1 returns :ok with valid geo" do
      geo = %{
        "type" => "Point",
        "coordinates" => [30, -90]
      }

      assert {:ok, _} = Partners.decode_geo(geo)
    end

    test "decode_geo/1 returns :error with invalid geo" do
      geo = %{
        "type" => "Point",
        "coordinates" => "invalid"
      }

      assert {:error, :invalid_geo} = Partners.decode_geo(geo)
    end
  end
end
