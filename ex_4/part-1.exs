html_colors = [
  MediumSlateBlue: "#7B68EE",
  MidnightBlue: "#191970",
  OrangeRed: "#FF4500",
  PaleVioletRed: "#DB7093",
  PeachPuff: "#FFDAB9",
  Pink: "#FFC0CB",
  PowderBlue: "#B0E0E6",
  Purple: "#800080",
  RoyalBlue: "#4169E1",
  BurlyWood: "#DEB887"
]

defmodule Colors do
  def colors(html_colors) do
    input = IO.gets("Enter the html value or the name of the desired color : ") |> String.trim()
    if Enum.any?(html_colors, fn {k, v} -> input == to_string(k) or input == v end) do
      for {key,value} <- html_colors do
        first_letter = String.at(input, 0)

        if first_letter == "#" && input == value do
          IO.puts("The name of this color is #{key}")
        else
          if input == to_string(key) do
            IO.puts("The html color value is #{value}")
          end
        end
      end
    else
      IO.puts("The input is not a valid color value or name.")
      Kernel.exit(:normal)
    end
    colors(html_colors) # allows loop to iterate forever
  end
end

Colors.colors(html_colors)
