class RectangleOutputHtml
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
    output = "<table>"
    two_d_array.each do |row|
      output += "<tr>"
      row.each do |column|
        output += "<td>" + map_column_to_output_symbol(column) + "</td>"
      end
      output += "</tr>"
    end
    output += "</table>"
    return output
  end
end
