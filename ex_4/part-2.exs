books = %{
  :isbn9780142424179 => "To Kill a Mockingbird",
  :isbn9781451673319 => "1984",
  :isbn9780743273565 => "The Catcher in the Rye",
  :isbn9780553382563 => "Fahrenheit 451",
  :isbn9780061120084 => "Animal Farm",
}

defmodule Books do
  def book_search(books) do
    IO.puts("1.list\n2.search ISBN\n3.add ISBN,NAME\n4.remove ISBN\n5.quit")
    input = IO.gets("Enter the number of desired command: ") |> String.trim() |> String.to_integer()
    # list
    if input == 1 do
      IO.puts("#####\n")
      IO.puts("The books names are: \n")
      Enum.each(Map.values(books), &IO.puts(&1))
      IO.puts("\n#####")
    end
    # search ISBN
    if input == 2 do
      IO.puts("#####\n")
      isbn = IO.gets("Enter the ISBN code: ") |> String.trim() |> String.to_existing_atom()
      IO.puts(books[isbn])
      IO.puts("\n#####")
    end
    # add ISBN,NAME
    if input == 3 do
      new_isbn = IO.gets("Enter the ISBN code of the new book: ") |> String.trim() |> String.to_atom()
      new_name = IO.gets("Enter the name of the new book: ") |> String.trim()
      book_update = Map.put(books, new_isbn, new_name)
      Books.book_search(book_update)
    end
    # remove ISBN
    if input == 4 do
      book_to_remove = IO.gets("Enter the ISBN code of the book you want to remove: ") |> String.trim() |> String.to_existing_atom()
      book_update = Map.delete(books, book_to_remove)
      Books.book_search(book_update)

    end
    # quit
    if input == 5 do
      Kernel.exit(:normal)
    end
    book_search(books) # allows loop to iterate forever
  end
end


Books.book_search(books)
