defmodule ZeexWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ZeexWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: ZeexWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: ZeexWeb.ErrorHTML, json: ZeexWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, :invalid_geo}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: ZeexWeb.ErrorJSON)
    |> render(:"422")
  end
end
