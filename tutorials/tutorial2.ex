defmodule M do

  def pow(exp, num) do
    pow(exp, num, num)
  end

  def pow(exp, num, _) when exp == 1 do
    num
  end

  def pow(exp, num, orig) do
    pow(exp - 1, num * orig, orig)
  end

end

square = fn num -> M.pow(2, num) end
cubed = fn num -> M.pow(3, num) end

IO.puts square.(4)
IO.puts cubed.(4)
