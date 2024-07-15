# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CartValleyServer.Repo.insert!(%CartValleyServer.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias CartValleyServer.Repo
alias CartValleyServer.Inventory.Product

if Mix.env() == :dev do
    for n <- 1..10 do
        Repo.insert!(%Product{
            name: "Product title #{n}",
            description: "Product description #{n}",
            price: 10.00 * n,
            quantity: 2 + n,
        })
    end
end

if Mix.env() == :test do
    Repo.delete_all(Product)
    Repo.insert!(%Product{
        id: 193,
        name: "Test seeded Product title",
        description: "Test seeded Product description",
        price: 99.00,
        quantity: 20,
    })
end
