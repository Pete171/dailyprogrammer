class RectangleOutputAscii
  attr_accessor :symbol_empty, :symbol_filled, :symbol_corner, :symbol_hwall, :symbol_vwall

  def initialize
    self.symbol_empty = ' '
    self.symbol_filled = ' '
    self.symbol_corner = '+'
    self.symbol_hwall = '-'
    self.symbol_vwall = '|'
  end

  def map_column_to_output_symbol(column)
    mapping = {
      RectangleGenerator::EMPTY => self.symbol_empty,
      RectangleGenerator::FILLED => self.symbol_filled,
      RectangleGenerator::H_WALL => self.symbol_hwall,
      RectangleGenerator::V_WALL => self.symbol_vwall,
      RectangleGenerator::CORNER => self.symbol_corner,
    }
    symbol = mapping.fetch(column, nil)
    raise sprintf("Column type %s not mapped.", column) if !symbol
    return symbol
  end

  def render(two_d_array)
    output = ""
    two_d_array.each do |row|
      row.each do |column|
        output += map_column_to_output_symbol(column)
      end
      output += "\n"
    end
    return output
  end
end
