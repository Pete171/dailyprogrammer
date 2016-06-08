require 'minitest/autorun'
require_relative '../lib/rectangle_generator'
require_relative '../lib/rectangle_output_ascii'

class RectangleGeneratorTest < Minitest::Test
  def setup
    @rectangle_generator = RectangleGenerator.new(RectangleOutputAscii.new)#TODO-use a stub...
  end

  [
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 2, col: 14, expected_return_value: RectangleGenerator::CORNER},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 2, col: 17, expected_return_value: RectangleGenerator::CORNER},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 7, col: 14, expected_return_value: RectangleGenerator::CORNER},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 7, col: 17, expected_return_value: RectangleGenerator::CORNER},

    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 2, col: 15, expected_return_value: RectangleGenerator::H_WALL},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 2, col: 16, expected_return_value: RectangleGenerator::H_WALL},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 7, col: 15, expected_return_value: RectangleGenerator::H_WALL},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 7, col: 16, expected_return_value: RectangleGenerator::H_WALL},

    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 3, col: 14, expected_return_value: RectangleGenerator::V_WALL},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 4, col: 14, expected_return_value: RectangleGenerator::V_WALL},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 5, col: 14, expected_return_value: RectangleGenerator::V_WALL},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 6, col: 14, expected_return_value: RectangleGenerator::V_WALL},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 3, col: 17, expected_return_value: RectangleGenerator::V_WALL},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 4, col: 17, expected_return_value: RectangleGenerator::V_WALL},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 5, col: 17, expected_return_value: RectangleGenerator::V_WALL},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 6, col: 17, expected_return_value: RectangleGenerator::V_WALL},

    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 3, col: 15, expected_return_value: RectangleGenerator::FILLED},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 3, col: 16, expected_return_value: RectangleGenerator::FILLED},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 4, col: 15, expected_return_value: RectangleGenerator::FILLED},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 4, col: 16, expected_return_value: RectangleGenerator::FILLED},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 5, col: 15, expected_return_value: RectangleGenerator::FILLED},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 5, col: 16, expected_return_value: RectangleGenerator::FILLED},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 6, col: 15, expected_return_value: RectangleGenerator::FILLED},
    { rectangle_p1: [2, 14], rectangle_p2: [7, 17], row: 6, col: 16, expected_return_value: RectangleGenerator::FILLED},
  ]#TODO - rename
  .each.with_index do |test_data, index|
    define_method("test_abc_#{index}") do
      rectangle = Rectangle.new(test_data[:rectangle_p1], test_data[:rectangle_p2]) #TODO - not stubbed!
      actual_return_value = @rectangle_generator.abc(rectangle, test_data[:row], test_data[:col])
      assert_equal(test_data[:expected_return_value], actual_return_value)
    end
  end

end
