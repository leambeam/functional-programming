defmodule Math do

  def add(a,b) do
    result = a + b
    IO.puts("#{math_info(a,b,"Adding")} = #{result}")
  end

  def sub(a,b) do
    result = a - b
    IO.puts("#{math_info(a,b,"Subtracting")} = #{result}")
  end

  def mul(a,b) do
    result = a * b
    IO.puts("#{math_info(a,b,"Multiplying")} = #{result}")
  end

  def div(a,b) do
    result = a / b
    IO.puts("#{math_info(a,b,"Dividing")} = #{result}")
  end

  defp math_info(a,b,operation) do
    "#{operation} #{a} and #{b}"
  end

end

defmodule Calculator do

  def calc(input) do
    if String.contains?(input, "+") do
      [a_str, b_str] = String.split(input, "+")
      a = String.to_integer(a_str)
      b = String.to_integer(b_str)
      Math.add(a,b)
    end

    if String.contains?(input, "-") do
      [a_str, b_str] = String.split(input, "-")
      a = String.to_integer(a_str)
      b = String.to_integer(b_str)
      Math.sub(a,b)
    end

    if String.contains?(input, "*") do
      [a_str, b_str] = String.split(input, "*")
      a = String.to_integer(a_str)
      b = String.to_integer(b_str)
      Math.mul(a,b)
    end

    if String.contains?(input, "/") do
      [a_str, b_str] = String.split(input, "/")
      a = String.to_integer(a_str)
      b = String.to_integer(b_str)
      Math.div(a,b)
    end
  end

end



defmodule Program do

  def main() do
    input = IO.gets("Enter the mathematical expression to be calculated with (+,-,*,/) in the following format: (5+5): ") |> String.trim

    # Exits if the entered text does not parse correctly
    try do
      Calculator.calc(input)
    rescue
      _ ->
        IO.puts("Your input is incorrect!!!")
        Kernel.exit(:normal)
    end
    
    main() # recursion
  end

end

Program.main()


"""
Correct input:

Enter the mathematical expression to be calculated with (+,-,*,/) in the following format: (5+5): 5+5
Adding 5 and 5 = 10

Incorrect input:

Enter the mathematical expression to be calculated with (+,-,*,/) in the following format: (5+5): 5+++5
Your input is incorrect!!!

"""
