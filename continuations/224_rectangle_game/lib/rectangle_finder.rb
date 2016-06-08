#https://www.reddit.com/r/dailyprogrammer/comments/3e5b0o/20150722_challenge_224_intermediate_detecting/

class RectangleFinder
  attr_accessor :horizontal_wall, :vertical_wall, :corner

  def initialize()
    self.corner = '+'
    self.horizontal_wall = '-'
    self.vertical_wall = '|'
  end

  def run(ascii)
    horizontal_rows = get_horizontal(ascii)
    vertical_rows = get_vertical(ascii)
    return get_count(horizontal_rows, vertical_rows)
  end

  def get_vertical(ascii)
    arr = ascii.split("\n").map { |line| line.split('') }
    transposed = arr.transpose
    transposed_str = transposed.map { |line| line.join('') }.join("\n")
    return _get_horizontal(transposed_str, self.vertical_wall)
  end

  def get_horizontal(ascii)
    return _get_horizontal(ascii, self.horizontal_wall)
  end

  def _get_horizontal(ascii, splitter)
    joined = []
    ascii.split("\n").each do |row|
      joined_on_row = []
      joined_horizontally = []
      joining = false
      row.chars.with_index.each do |char, char_pos|
        joining = [self.corner,splitter].include?(char)
        joined_horizontally.push(char_pos) if char == self.corner
        if (!joining && !joined_horizontally.empty? || char_pos == row.length-1) then
          joined_on_row.push(*joined_horizontally.combination(2).to_a)
          joined_horizontally = []
        end
      end
      joined.push(joined_on_row)
    end
    return joined
  end

  def get_count(horizontal_rows, vertical_rows)
    count = 0
    horizontal_rows.each.with_index do |row, h_index_1|
      row.each do |side_to_find|
        horizontal_rows[h_index_1..-1].each.with_index do |row2, h_index_2|
          next if !row2.include?(side_to_find)
          pair = [h_index_1, h_index_2 + h_index_1]
          count += 1 if vertical_rows[side_to_find[0]].include?(pair) && vertical_rows[side_to_find[1]].include?(pair)
        end
      end
    end
    return count
  end
end
