defmodule BooksApiWeb.BookControllerTest do
  use BooksApiWeb.ConnCase

  import BooksApi.StoreFixtures

  alias BooksApi.Store.Book

  @create_attrs %{
    authors: ["option1", "option2"],
    description: "some description",
    isbn: "some isbn",
    price: 120.5,
    title: "some title"
  }
  @update_attrs %{
    authors: ["option1"],
    description: "some updated description",
    isbn: "some updated isbn",
    price: 456.7,
    title: "some updated title"
  }
  @invalid_attrs %{authors: nil, description: nil, isbn: nil, price: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all books", %{conn: conn} do
      conn = get(conn, ~p"/api/books")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create book" do
    test "renders book when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/books", book: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/books/#{id}")

      assert %{
               "id" => ^id,
               "authors" => ["option1", "option2"],
               "description" => "some description",
               "isbn" => "some isbn",
               "price" => 120.5,
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post(conn, ~p"/api/books", book: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "update book" do
    setup [:create_book]

    test "renders book when data is valid", %{conn: conn, book: %Book{id: id} = book} do
      conn = put(conn, ~p"/api/books/#{book}", book: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/books/#{id}")

      assert %{
               "id" => ^id,
               "authors" => ["option1"],
               "description" => "some updated description",
               "isbn" => "some updated isbn",
               "price" => 456.7,
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    # test "renders errors when data is invalid", %{conn: conn, book: book} do
    #   conn = put(conn, ~p"/api/books/#{book}", book: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "delete book" do
    setup [:create_book]

    test "deletes chosen book", %{conn: conn, book: book} do
      conn = delete(conn, ~p"/api/books/#{book}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/books/#{book}")
      end
    end
  end

  defp create_book(_) do
    book = book_fixture()
    %{book: book}
  end
end
