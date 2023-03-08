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


Math.add(10,5) # Adding 10 and 5 = 15
Math.sub(10,5) # Subtracting 10 and 5 = 5
Math.mul(10,5) # Multiplying 10 and 5 = 50
Math.div(10,5) # Dividing 10 and 5 = 2.0
