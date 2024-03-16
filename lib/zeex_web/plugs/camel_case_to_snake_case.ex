defmodule ZeexWeb.CamelCaseToSnakeCase do
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{params: params} = conn, _opts) do
    transformed_params = transform_keys_to_snake_case(params)
    put_private(conn, :transformed_params, transformed_params)
  end

  defp transform_keys_to_snake_case(params) when is_map(params) do
    Enum.reduce(params, %{}, fn {k, v}, acc ->
      {new_key, new_value} = transform_key_value({k, v})
      Map.put(acc, new_key, new_value)
    end)
  end

  defp transform_key_value({key, value}) when is_map(value) do
    {Phoenix.Naming.underscore(key), transform_keys_to_snake_case(value)}
  end

  defp transform_key_value({key, value}), do: {Phoenix.Naming.underscore(key), value}
end
