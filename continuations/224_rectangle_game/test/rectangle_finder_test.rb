require 'minitest/autorun'
require_relative '../lib/rectangle_finder'

class RectangleFinderTest < Minitest::Test
  def setup
    @rectangle_finder = RectangleFinder.new
  end

  def test_get_horizontal
    input = <<-ASCII
      +-+ +
      | +-+
      | |  
      +-+-+
      +-+ +-+
    ASCII
    expected_return_value = [
      [[6, 8]],
      [[8, 10]],
      [],
      [[6, 8], [6, 10], [8, 10]],
      [[6, 8], [10, 12]],
    ]
    actual_return_value = @rectangle_finder.get_horizontal(input)
    assert_equal(expected_return_value, actual_return_value)
  end

  def test_get_vertical
    input = <<-ASCII
      +-+ +  
      | +-+  
      | |    
      +-+-+  
      +-+ +-+
    ASCII
    expected_return_value = [
     [],
     [],
     [],
     [],
     [],
     [],
     [[0, 3], [0, 4], [3, 4]],
     [],
     [[0, 1], [0, 3], [0, 4], [1, 3], [1, 4], [3, 4]], 
     [], 
     [[0, 1], [3, 4]], 
     [], 
     []
    ]
    actual_return_value = @rectangle_finder.get_vertical(input)
    assert_equal(expected_return_value, actual_return_value)
  end

  def test_get_count
    horizontal_sides = [
      [[6, 8]],
      [[8, 10]],
      [],
      [[6, 8], [6, 10], [8, 10]],
      [[6, 8], [10, 12]],
    ]
    vertical_sides = [
     [],
     [],
     [],
     [],
     [],
     [],
     [[0, 3], [0, 4], [3, 4]],
     [],
     [[0, 1], [0, 3], [0, 4], [1, 3], [1, 4], [3, 4]], 
     [], 
     [[0, 1], [3, 4]], 
     [], 
     []
    ]
    expected_return_value = 3
    actual_return_value = @rectangle_finder.get_count(horizontal_sides, vertical_sides)
    assert_equal(expected_return_value, actual_return_value)
  end

  [
    {
      ascii: <<-ASCII, expected_return_value: 3
      +-+ +  
      | +-+  
      | |    
      +-+-+  
      +-+ +-+
      ASCII
    },
    {
      ascii: <<-ASCII, expected_return_value: 25
                                +----+
                                |    |
+-------------------------+-----+----+
|                         |     |    |
|     +-------------------+-----+    |
|     |                   |     |    |
|     |                   |     |    |
+-----+-------------------+-----+    |
      |                   |     |    |
      |                   |     |    |
      +-------------------+-----+    |
                          |     |    |
                          |     |    |
                          |     |    |
                          +-----+----+
                                |    |
                                |    |
                                |    |
                                +----+
      ASCII
    },
    {
      ascii: <<-ASCII, expected_return_value: 25
              +-----------+              
              |           |              
              |           |              
              |           |              
              |           |              
+-------------+-----------+-------------+
|             |           |             |
|             |           |             |
|             |           |             |
|             |           |             |
+-------------+-----------+-------------+
              |           |              
              |           |              
              |           |              
              |           |              
+-------------+-----------+-------------+
|             |           |             |
|             |           |             |
|             |           |             |
|             |           |             |
+-------------+-----------+-------------+
              |           |              
              |           |              
              |           |              
              |           |              
              +-----------+              
      ASCII
    },
    {
      ascii: <<-ASCII, expected_return_value: 8
 +---------+
 |         |
 |         |
 |         |
 +---+---+-+
 |   |   | |
 |   |   | |
 +---+---+-+
      ASCII
    },
  ]
  .each.with_index do |data_set, index|
    define_method("test_run_#{index}") do 
      expected_return_value = data_set.fetch(:expected_return_value)
      actual_return_value = @rectangle_finder.run(data_set.fetch(:ascii))
      assert_equal(expected_return_value, actual_return_value)
    end
  end

  [
    {
      ascii: <<-ASCII, expected_return_value: 3
      ABA A  
      C ABA  
      C C    
      ABABA  
      ABA ABA
      ASCII
    },
  ]
  .each.with_index do |data_set, index|
    define_method("test_run_with_non_default_characters_#{index}") do
      @rectangle_finder.corner = 'A'
      @rectangle_finder.horizontal_wall = 'B'
      @rectangle_finder.vertical_wall = 'C'
      expected_return_value = data_set.fetch(:expected_return_value)
      actual_return_value = @rectangle_finder.run(data_set.fetch(:ascii))
      assert_equal(expected_return_value, actual_return_value)
    end
  end
end
