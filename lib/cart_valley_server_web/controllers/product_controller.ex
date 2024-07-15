defmodule CartValleyServerWeb.ProductController do
  use CartValleyServerWeb, :controller

  alias CartValleyServer.Inventory
  alias CartValleyServer.Inventory.Product

  action_fallback CartValleyServerWeb.FallbackController

  def index(conn, _params) do
    products = Inventory.list_products()
    render(conn, :index, products: products)
  end

  def create(conn, %{"product" => product_params}) do
    with {:ok, %Product{} = product} <- Inventory.create_product(product_params) do
      conn
      |> put_status(:created)
      |> render(:show, product: product)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Inventory.get_product!(id)
    render(conn, :show, product: product)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Inventory.get_product!(id)

    with {:ok, %Product{} = product} <- Inventory.update_product(product, product_params) do
      render(conn, :show, product: product)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Inventory.get_product!(id)

    with {:ok, %Product{}} <- Inventory.delete_product(product) do
      send_resp(conn, :no_content, "")
    end
  end

  def update_quantity(conn, %{"_json" => product_params_list}) when is_list(product_params_list) do
    results = Enum.map(product_params_list, fn %{"id" => id, "sold" => sold_qty} ->
      product = Inventory.get_product!(id)

      # Calculate the new quantity
      new_quantity = product.quantity - sold_qty

      # Update the product's attributes
      updated_product_params = %{"quantity" => new_quantity}

      # Update the product in the database
      Inventory.update_product(product, updated_product_params)
    end)

    if Enum.all?(results, fn {:ok, _} -> true; _ -> false end) do
      # If all products were updated successfully, return a 200 OK status and a JSON response with a success message
      conn
      |> put_status(:ok)
      |> json(%{message: "All products updated successfully"})
    else
      # Otherwise, filter out any errors from the results
      # Return a 422 Unprocessable Entity status and a JSON response with the errors
      conn
      |> put_status(:unprocessable_entity)
      |> json(%{message: "Error processing request"})
    end
  end
end
