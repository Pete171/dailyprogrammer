require 'minitest/autorun'
require_relative '../lib/rectangle'

class RectangleTest < Minitest::Test
  def setup
    #@rectangle = Rectangle.new
  end

  def _new_rectangle(p1, p2)
    return Rectangle.new(p1, p2)
  end

  [
   { point1: [2,3], point2: [3,4] },
   { point1: [3,4], point2: [2,3] },
  ]
  .each.with_index do |test_data, index|
    define_method("test_iterate_#{index}") do
      expected_calls = [
        [2, 3],
        [2, 4],
        [3, 3],
        [3, 4],
      ]

      rectangle = _new_rectangle(test_data.fetch(:point1), test_data.fetch(:point2))
      index = 0
      rectangle.iterate do |row, col|
        assert_equal(expected_calls[index][0], row)
        assert_equal(expected_calls[index][1], col)
        index += 1
      end
    end
  end

  def test_iterate_With_no_block
    rectangle = _new_rectangle([2,3],[3,4])
    assert_raises(RuntimeError) do
      rectangle.iterate
    end
  end

  def test_initialize_When_rows_are_the_same
    assert_raises(RuntimeError) do
      _new_rectangle([2,3],[2,4])
    end
  end

  def test_initialize_When_columns_are_the_same
    assert_raises(RuntimeError) do
      _new_rectangle([2,3],[3,3])
    end
  end
end
