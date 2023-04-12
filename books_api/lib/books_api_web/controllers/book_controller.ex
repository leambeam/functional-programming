defmodule BooksApiWeb.BookController do
  use BooksApiWeb, :controller

  alias BooksApi.Store
  alias BooksApi.Store.Book

  action_fallback BooksApiWeb.FallbackController

  def index(conn, _params) do
    books = Store.list_books()
    render(conn, :index, books: books)
  end

  def create(conn, %{"book" => book_params}) do
    with {:ok, %Book{} = book} <- Store.create_book(book_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/books/#{book}")
      |> render(:show, book: book)
    end
  end

  def show(conn, %{"id" => id}) do
    book = Store.get_book!(id)
    render(conn, :show, book: book)
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    book = Store.get_book!(id)

    with {:ok, %Book{} = book} <- Store.update_book(book, book_params) do
      render(conn, :show, book: book)
    end
  end

  def delete(conn, %{"id" => id}) do
    book = Store.get_book!(id)

    with {:ok, %Book{}} <- Store.delete_book(book) do
      send_resp(conn, :no_content, "")
    end
  end
end
