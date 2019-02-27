defmodule RopeLengthCalculatorTest do
  use ExUnit.Case
  doctest RopeLengthCalculator

  test "calculates correct length" do
    shapes = [
      [
        {-1, 2},
        {0, 4},
        {2, 5},
        {6, 6},
        {6, 2},
        {3, 2}
      ],
      [
        {0, 3},
        {-1, 1},
        {-3, 1},
        {-4, 3},
        {-2, 4}
      ],
      [
        {0, 0},
        {1, 1},
        {1, -2}
      ]
    ]
    assert RopeLengthCalculator.calculate(shapes) == 28.121471443667748
  end
end
