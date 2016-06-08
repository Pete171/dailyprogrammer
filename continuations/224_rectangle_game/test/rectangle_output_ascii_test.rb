require 'minitest/autorun'
require_relative '../lib/rectangle_output_ascii'
require_relative '../lib/rectangle_generator'

class RectangleOutputAsciiTest < Minitest::Test
  def setup
    @rectangle_output_ascii = RectangleOutputAscii.new
  end

  [
    { input: RectangleGenerator::EMPTY, expected_return_value: ' ' },
    { input: RectangleGenerator::FILLED, expected_return_value: ' ' },
    { input: RectangleGenerator::H_WALL, expected_return_value: '-' },
    { input: RectangleGenerator::V_WALL, expected_return_value: '|' },
    { input: RectangleGenerator::CORNER, expected_return_value: '+' },
  ]
  .each.with_index do |test_data, index|
    define_method("test_map_column_to_output_symbol_Using_default_values_#{index}") do
      actual_return_value = @rectangle_output_ascii.map_column_to_output_symbol(test_data.fetch(:input))
      assert_equal(test_data.fetch(:expected_return_value), actual_return_value)
    end
  end

  [
    { input: RectangleGenerator::EMPTY, expected_return_value: 'A' },
    { input: RectangleGenerator::FILLED, expected_return_value: 'B' },
    { input: RectangleGenerator::H_WALL, expected_return_value: 'C' },
    { input: RectangleGenerator::V_WALL, expected_return_value: 'D' },
    { input: RectangleGenerator::CORNER, expected_return_value: 'E' },
  ]
  .each.with_index do |test_data, index|
    define_method("test_map_column_to_output_symbol_Using_custom_values_#{index}") do
      @rectangle_output_ascii.symbol_empty = 'A'
      @rectangle_output_ascii.symbol_filled = 'B'
      @rectangle_output_ascii.symbol_hwall = 'C'
      @rectangle_output_ascii.symbol_vwall = 'D'
      @rectangle_output_ascii.symbol_corner = 'E'
      actual_return_value = @rectangle_output_ascii.map_column_to_output_symbol(test_data.fetch(:input))
      assert_equal(test_data.fetch(:expected_return_value), actual_return_value)
    end
  end
  
  def test_map_column_to_output_symbol_With_invalid_input
    assert_raises(RuntimeError) do
      @rectangle_output_ascii.map_column_to_output_symbol(100)
    end
  end

  def test_render
    input_grid = [[0, 0, 0, 0, 0, 0, 0, 4, 2, 2, 4, 0], [4, 2, 2, 2, 4, 0, 0, 3, 1, 1, 3, 0], [3, 1, 1, 1, 3, 0, 0, 3, 1, 1, 3, 0], [3, 1, 1, 1, 3, 0, 0, 3, 1, 1, 3, 0], [4, 2, 2, 2, 4, 2, 2, 4, 2, 2, 4, 0], [3, 1, 1, 1, 3, 1, 1, 3, 1, 1, 3, 0], [3, 1, 1, 1, 3, 1, 1, 3, 1, 1, 3, 0], [3, 1, 1, 1, 3, 1, 1, 3, 1, 1, 3, 0], [3, 1, 1, 1, 3, 1, 1, 3, 1, 1, 3, 0], [4, 2, 2, 2, 4, 2, 2, 4, 2, 2, 4, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]

    expected_output = <<EXPECTED_OUTPUT
       +--+ 
+---+  |  | 
|   |  |  | 
|   |  |  | 
+---+--+--+ 
|   |  |  | 
|   |  |  | 
|   |  |  | 
|   |  |  | 
+---+--+--+ 
            
            
EXPECTED_OUTPUT
    actual_output = @rectangle_output_ascii.render(input_grid)
    assert_equal(expected_output, actual_output)
  end
end
