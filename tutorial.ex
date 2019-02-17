defmodule M do

  def main do

    t = fn (x, _y) -> x end
    f = fn (_x, y) -> y end
    n = fn (b) -> b.(f, t) end
    o = fn (x, y) -> x.(t, y) end
    a = fn (x, y) -> x.(y, f) end
    z = fn (x, y) -> a.(o.(x, y), n.(a.(x, y))) end

    name = fn (l) -> if l == f, do: "false", else: "true" end

    IO.puts (name.(a.(t, f)))
    IO.puts (name.(o.(f, f)))

    IO.puts (name.(z.(t, t)))
    IO.puts (name.(z.(f, t)))
    IO.puts (name.(z.(t, f)))
    IO.puts (name.(z.(f, f)))
    #IO.puts (a.(t, t))
  end
end