# Multiplication
multiply = fn a,b,c -> a*b*c end

a = IO.gets("Enter the first number: ")  |> String.trim() |> String.to_integer()
b = IO.gets("Enter the second number: ") |> String.trim() |> String.to_integer()
c = IO.gets("Enter the third number: ") |> String.trim() |> String.to_integer()

result = multiply.(a,b,c)
IO.puts("Result of the multiplication: #{result}")

# Lists concatenation
concat = fn list1, list2 -> list1 ++ list2 end

list1 = [1,2,3]
list2 = [4,5,6]

conc = concat.(list1,list2)
IO.puts("Concat lists: #{inspect(conc)}")


#Adding a new value to the tuple
tuple = {:ok,:fail}
appended_tuple = Tuple.append(tuple, :canceled)
IO.puts("Tuple: #{inspect(appended_tuple)}")
