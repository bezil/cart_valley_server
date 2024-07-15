defmodule CartValleyServerWeb.ProductControllerTest do
  use CartValleyServerWeb.ConnCase

  import CartValleyServer.InventoryFixtures

  alias CartValleyServer.Inventory.Product

  @create_attrs %{
    name: "some name",
    description: "some description",
    price: "120.50",
    quantity: 42
  }
  @update_attrs %{
    name: "some updated name",
    description: "some updated description",
    price: "456.70",
    quantity: 43
  }
  @invalid_attrs %{name: nil, description: nil, price: nil, quantity: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      # Send an HTTP GET request to the "/api/products" endpoint
      conn = get(conn, ~p"/api/products")

      [response_data] = json_response(conn, 200)["data"]

      # Parse the JSON response body and assert that the "data" field is same as seeded data
      assert %{
        "description" => "Test seeded Product description",
        "id" => _id,
        "name" => "Test seeded Product title",
        "price" => "99.00",
        "quantity" => 20
      } = response_data
    end
  end

  describe "create product" do
    test "renders product when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/products", product: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/products/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "name" => "some name",
               "price" => "120.50",
               "quantity" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/products", product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update product" do
    setup [:create_product]

    test "renders product when data is valid", %{conn: conn, product: %Product{id: id} = product} do
      conn = put(conn, ~p"/api/products/#{product}", product: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/products/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "name" => "some updated name",
               "price" => "456.70",
               "quantity" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put(conn, ~p"/api/products/#{product}", product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update_quantity" do
    setup do
      # Insert necessary products into the database
      product1 = %{name: "Product 192", quantity: 10, price: 100.0, description: "Some description"}
      product2 = %{name: "Product 193", quantity: 10, price: 100.0, description: "Some description"}

      {:ok, product_1} = CartValleyServer.Inventory.create_product(product1)
      {:ok, product_2} = CartValleyServer.Inventory.create_product(product2)

      # Return products in the test context
      %{product_1: product_1, product_2: product_2}
    end

    test "updates product quantities successfully", %{conn: conn, product_1: product_1, product_2: product_2} do
      product_params_list = [
        %{"id" => product_1.id, "sold" => 1},
        %{"id" => product_2.id, "sold" => 2}
      ]

      conn = post(conn, ~p"/api/products/update-quantity", %{_json: product_params_list})
      # Fetch the updated product_1 from the database
      updated_product_1 = CartValleyServer.Inventory.get_product!(product_1.id)

      assert conn.status == 200
      assert json_response(conn, 200)["message"] == "All products updated successfully"
      # Assert the quantity has changed to 9
      assert updated_product_1.quantity == 9
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      conn = delete(conn, ~p"/api/products/#{product}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/products/#{product}")
      end
    end
  end

  defp create_product(_) do
    product = product_fixture()
    %{product: product}
  end
end
