consonants = ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z", "B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Y", "Z"]
vowels = ["a", "e", "i", "o", "u", "A", "E", "I", "O", "U"]
groups_of_consonants = ["ch", "qu", "squ", "th", "thr", "sch"]
groups_of_vowels = ["yt","xr"]

str = "Pattern Matching with Elixir. Remember that equals sign is a match operator, not an assignment"
|> String.split() # splitting a string into a list of strings

pig_latin = for x <- str do
  first_letter = String.at(x,0)
  remove_letter = String.replace_prefix(x,first_letter,"") # removing the first letter of the string
  if Enum.member?(consonants,first_letter) || Enum.member?(groups_of_consonants,first_letter) do
    consonants_str = remove_letter <> first_letter <> "ay" # adding the first letter to the back following by "ay"
    consonants_str
  else
    if Enum.member?(vowels,first_letter) || Enum.member?(groups_of_vowels,first_letter) do
      vowels_str = x <> "ay"
      vowels_str
    end
  end
end

IO.puts(Enum.join(pig_latin, " "))



