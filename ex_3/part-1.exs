number = IO.gets("Enter the number: ") |> String.trim() |> String.to_integer()

defmodule Remainder do
  def smallest_remainder(number) do
    divisor = Enum.find(2..(number + 2), fn divisor -> rem(number, divisor) == 0 end)
    IO.puts("Divisible by #{divisor}")
  end

  def remainder(number) do
    cond do
      rem(number, 3) == 0 -> IO.puts("Divisible by 3")
      rem(number, 5) == 0 -> IO.puts("Divisible by 5")
      rem(number, 7) == 0 -> IO.puts("Divisible by 7")
      true -> smallest_remainder(number)
    end
  end
end


Remainder.remainder(number)
