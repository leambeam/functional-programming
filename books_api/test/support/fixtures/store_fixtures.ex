defmodule BooksApi.StoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BooksApi.Store` context.
  """

  @doc """
  Generate a unique book isbn.
  """
  def unique_book_isbn, do: "some isbn#{System.unique_integer([:positive])}"

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(%{
        authors: ["option1", "option2"],
        description: "some description",
        isbn: unique_book_isbn(),
        price: 120.5,
        title: "some title"
      })
      |> BooksApi.Store.create_book()

    book
  end
end
