defmodule BooksApiWeb.BookJSON do
  alias BooksApi.Store.Book

  @doc """
  Renders a list of books.
  """
  def index(%{books: books}) do
    %{data: for(book <- books, do: data(book))}
  end

  @doc """
  Renders a single book.
  """
  def show(%{book: book}) do
    %{data: data(book)}
  end

  defp data(%Book{} = book) do
    %{
      id: book.id,
      title: book.title,
      isbn: book.isbn,
      description: book.description,
      price: book.price,
      authors: book.authors
    }
  end
end
