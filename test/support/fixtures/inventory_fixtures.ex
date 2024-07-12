defmodule CartValleyServer.InventoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CartValleyServer.Inventory` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        price: "120.50",
        quantity: 42
      })
      |> CartValleyServer.Inventory.create_product()

    product
  end
end
