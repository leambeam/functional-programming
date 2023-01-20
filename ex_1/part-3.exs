get_input = IO.gets("Write something: ")
str_length = String.trim(get_input) |> String.replace(~r/\s/, "") |> String.length()
IO.puts("The legth of the string is: #{str_length}")

str_reverse = String.reverse(get_input)
IO.puts("Reversed input: #{str_reverse}")

str_split = String.replace(get_input,"foo","bar")
IO.puts("Replaced foo with bar: #{str_split} ")
