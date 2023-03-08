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


Calculator.calc("10+5") # Adding 10 and 5 = 15
Calculator.calc("10-5") # Subtracting 10 and 5 = 5
Calculator.calc("10*5") # Multiplying 10 and 5 = 50
Calculator.calc("10/5") # Dividing 10 and 5 = 2.0
