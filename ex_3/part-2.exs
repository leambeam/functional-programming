f = fn
  a, b when is_binary(a) and is_binary(b) -> a <> b
  (a, b) -> a + b
end

IO.puts f.(5,5)
IO.puts f.("Hello,"," world!")
