# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Zeex.Repo.insert!(%Zeex.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

json = File.read!("challenge/pdvs.json")
%{"pdvs" => pdvs} = Jason.decode!(json)

for pdv <- pdvs do
  Zeex.Store.create_partner(%{
    address: Geo.JSON.decode(pdv["address"]),
    coverage_area: Geo.JSON.decode(pdv["coverageArea"]),
    document: pdv["document"],
    owner_name: pdv["ownerName"],
    trading_name: pdv["tradingName"]
  })
end
