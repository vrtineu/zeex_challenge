# Zeex Challenge

This is a repository made for the Zé Delivery challenge. The goal is to create an API that can handle the creation of a store with its address and coverage area to be used in the Zé Delivery platform. The API should be able to create, update, delete and list stores, as well as check if a given point is inside one or more store's coverage areas and handle it giving the closest store to the point, if any.

## How to run

You need to have rigth version of Elixir and Erlang installed in your machine. You can check the versions in the `.tool-versions` file. You can use [asdf](https://asdf-vm.com/) to install the right versions.

You also need to have a Postgis database running in your machine. You can use the following docker command to run a Postgis database:

```bash
docker run --name postgis -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgis/postgis
```

After that, you can run the following steps to run the project:

* Run `mix setup` to install and setup dependencies and also create the database and run the migrations/seed.
* Run `mix phx.server` to start the server.

The server will be available at `http://localhost:4000`.

## How to test

You can use [geojson.io](https://geojson.io/) to have a visual representation of the data and test the API. You can access the `challenge` folder, open the `pdvs_to_geojson.json` file, and copy its content. Then, you can paste it into the mentioned website to see the stores and coverage areas. You can also use the site to create new points to obtain the latitude and longitude to use in the API.
