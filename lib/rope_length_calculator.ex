defmodule RopeLengthCalculator do

  def get_points_from_shapes([]) do
    []
  end

  def get_points_from_shapes([ head | tail ]) do
    get_points_from_shapes(tail) ++ get_points_from_shape(head)
  end

  def get_points_from_shape([]) do
    []
  end

  def get_points_from_shape([ head | tail ]) do
    get_points_from_shape(tail) ++ [head]
  end

  def get_most([], _) do
    nil
  end

  def get_most([ head ], _) do
    head
  end

  def get_most([ head | tail], comp) do
    comp.(head, get_most(tail, comp))
  end

  def x(point) do
    elem(point, 0)
  end

  def y(point) do
    elem(point, 1)
  end

  def is_above_line(point, slope, intersect) do
    y(point) > slope * x(point) + intersect
  end

  def is_below_line(point, slope, intersect) do
    y(point) < slope * x(point) + intersect
  end

  def filter([], _) do
    []
  end

  def filter([ head | tail ], filtr) do
    if(filtr.(head)) do
      filter(tail, filtr) ++ [head]
    else
      filter(tail, filtr)
    end
  end

  def min(x, min) do
    if (x < min) do
      min
    else
      x
    end
  end

  def get_slope(point_1, point_2) do
    bottom = x(point_2) - x(point_1)
    if (bottom == 0) do
      nil
    else
      (y(point_2) - y(point_1)) / bottom
    end
  end

  def get_intersect(slope, point) do
    -(x(point) * slope) + y(point)
  end

  def get_points_below_line(_, nil, _) do
    []
  end

  def get_points_below_line(points, slope, point) do
    intersect = get_intersect(slope, point)
    filter(points, fn p -> RopeLengthCalculator.is_below_line(p, slope, intersect) end)
  end

  def get_points_above_line(_, nil, _) do
    []
  end

  def get_points_above_line(points, slope, point) do
    intersect = get_intersect(slope, point)
    filter(points, fn p -> RopeLengthCalculator.is_above_line(p, slope, intersect) end)
  end

  # for safety, in case an empty list is given
  def calculate_point_distance([]) do
    0
  end

  def calculate_point_distance([ _ ]) do
    0
  end

  def calculate_point_distance([ head | tail ]) do
    next = Enum.at(tail, 0)
    calculate_point_distance(tail) + (:math.sqrt(:math.pow(x(next) - x(head), 2) + :math.pow(y(next) - y(head), 2)))
  end

  def calculate(shapes) do
    # get all points from shapes
    points = get_points_from_shapes(shapes)

    get_greatest = fn val1, val2, index ->
      if elem(val1, index) > elem(val2, index) do val1 else val2 end
    end

    get_least = fn val1, val2, index ->
      if elem(val1, index) < elem(val2, index) do val1 else val2 end
    end

    get_greatestX = fn val1, val2 ->
      get_greatest.(val1, val2, 0)
    end

    get_greatestY = fn val1, val2 ->
      get_greatest.(val1, val2, 1)
    end

    get_leastX = fn val1, val2 ->
      get_least.(val1, val2, 0)
    end

    get_leastY = fn val1, val2 ->
      get_least.(val1, val2, 1)
    end

    # Get points at extremes
    left = RopeLengthCalculator.get_most(points, get_leastX)
    right = RopeLengthCalculator.get_most(points, get_greatestX)
    top = RopeLengthCalculator.get_most(points, get_greatestY)
    bottom = RopeLengthCalculator.get_most(points, get_leastY)

    left_bottom_slope = RopeLengthCalculator.get_slope(left, bottom)
    left_top_slope = RopeLengthCalculator.get_slope(left, top)
    right_bottom_slope = RopeLengthCalculator.get_slope(right, bottom)
    right_top_slope = RopeLengthCalculator.get_slope(right, top)

    left_bottom_points = RopeLengthCalculator.get_points_below_line(points, left_bottom_slope, left)
    left_top_points = RopeLengthCalculator.get_points_above_line(points, left_top_slope, left)
    right_bottom_points = RopeLengthCalculator.get_points_below_line(points, right_bottom_slope, right)
    right_top_points = RopeLengthCalculator.get_points_above_line(points, right_top_slope, right)

    # sort points found outside lines to accurated calculate distance
    left_bottom_sort = fn p1, p2 ->
      p1X = RopeLengthCalculator.x(p1)
      p2X = RopeLengthCalculator.x(p2)

      if(p1X == p2X) do
        RopeLengthCalculator.y(p1) > RopeLengthCalculator.y(p2)
      else
        p1X < p2X
      end
    end

    left_top_sort = fn p1, p2 ->
      p1X = RopeLengthCalculator.x(p1)
      p2X = RopeLengthCalculator.x(p2)

      if(p1X == p2X) do
        RopeLengthCalculator.y(p1) > RopeLengthCalculator.y(p2)
      else
        p1X > p2X
      end
    end

    right_bottom_sort = fn p1, p2 ->
      p1X = RopeLengthCalculator.x(p1)
      p2X = RopeLengthCalculator.x(p2)

      if(p1X == p2X) do
        RopeLengthCalculator.y(p1) < RopeLengthCalculator.y(p2)
      else
        p1X < p2X
      end
    end

    right_top_sort = fn p1, p2 ->
      p1X = RopeLengthCalculator.x(p1)
      p2X = RopeLengthCalculator.x(p2)

      if(p1X == p2X) do
        RopeLengthCalculator.y(p1) < RopeLengthCalculator.y(p2)
      else
        p1X > p2X
      end
    end

    left_bottom_points = Enum.sort(left_bottom_points, left_bottom_sort)
    left_top_points = Enum.sort(left_top_points, left_top_sort)
    right_bottom_points = Enum.sort(right_bottom_points, right_bottom_sort)
    right_top_points = Enum.sort(right_top_points, right_top_sort)

    # put all line points in one list
    linePoints = [left] ++ left_bottom_points ++
                [bottom] ++ right_bottom_points ++
                [right] ++ right_top_points ++
                [top] ++ left_top_points ++
                [left]

    RopeLengthCalculator.calculate_point_distance(linePoints)
  end

end

shapes = [
  [
    {0, 0},
    {0, 2},
    {2, 2}
  ],
  [
    {0, 0},
    {2, 2},
    {2, 0}
  ]
]

shapes2 = [
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

IO.puts(RopeLengthCalculator.calculate(shapes2))
