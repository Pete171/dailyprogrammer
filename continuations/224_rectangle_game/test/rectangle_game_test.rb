require 'minitest/autorun'
require_relative '../lib/rectangle_finder'

class RectangleGameTest < Minitest::Test
  def setup
    @rectangle_game = RectangleGame.new
  end
end
