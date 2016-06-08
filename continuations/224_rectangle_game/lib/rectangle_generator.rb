require_relative 'rectangle'

class RectangleGenerator
  EMPTY = 0
  FILLED = 1
  H_WALL = 2
  V_WALL = 3
  CORNER = 4

  attr_accessor :row_count, :col_count, :min_rectangle_height, :max_rectangle_height, :min_rectangle_width, :max_rectangle_width, :min_rectangles, :max_rectangles, :escape_count, :outputter

  def initialize(outputter)
    self.row_count = 12
    self.col_count = 12
    self.min_rectangle_height = 3
    self.max_rectangle_height = 5
    self.min_rectangle_width = 3
    self.max_rectangle_width = 5   #TODO-validate these when setting so can't exteed row counts and that min width >= max width etc
    self.min_rectangles = 3
    self.max_rectangles = 12
    self.escape_count = 500
    self.outputter = outputter
    reset
  end

  def reset
    @rows = Array.new(self.row_count) { |index| Array.new(self.col_count, EMPTY) }
    @corner_cache = []
    @rectangle_count = 0
  end

  def abc(rectangle, row, col)
    hwall = true if rectangle.p1[0] == row || rectangle.p2[0] == row
    vwall = true if rectangle.p1[1] == col || rectangle.p2[1] == col
    corner = true if vwall && hwall
    if corner
      type = CORNER
      @corner_cache.push([row, col])
    elsif vwall
      type = V_WALL
    elsif hwall
      type = H_WALL
    else
      type = FILLED
    end
    return type
  end

  def build_rectangle(rectangle)
    rectangle.iterate do |row, col|
      puts "iterating " + row.to_s + " and col " + col.to_s
      #return if @rows[row][col] == CORNER #TODO - (i added a TODO but didn't comment why... i think it was bad design? review...)
      next if @rows[row][col] == CORNER #TODO - this used to be return (see above)
      type = abc(rectangle, row, col)
      @rows[row][col] = type
    end
    @rectangle_count += 1
  end

  def find_random_contiguous_corner(base_corner)
    @corner_cache.select { |corner| (base_corner[0] == corner[0]) ^ (base_corner[1] == corner[1]) }.sample
  end

  def extend_random
    random_corner = @corner_cache.sample
    contiguous_corner = find_random_contiguous_corner(random_corner)

    symbol = [:-, :+].sample

    if random_corner[0] == contiguous_corner[0] then #rows are the same - extending up/down
      random_offset = (self.min_rectangle_width..self.max_rectangle_width).to_a.sample

      row = random_corner[0] # could be from cont too
      lowest = random_corner[1] < contiguous_corner[1] ? random_corner : contiguous_corner#TODO-could use enumerable#min/max?
      heighest = random_corner[1] > contiguous_corner[1] ? random_corner : contiguous_corner
      p1 = [row, lowest[1]]
      p2 = [row.send(symbol, random_offset), heighest[1]]
      
      return if p2[0] >= self.row_count || p2[0] < 0
      return if p2[1] >= self.col_count || p2[1] < 0

      ignore = []
      (lowest[1]..heighest[1]).to_a.each do |col|
        ignore.push([row,col])
      end
    else # cols are the same - extending left/right
      random_offset = (self.min_rectangle_height..self.max_rectangle_height).to_a.sample

      col = random_corner[1] # could be from cont too
      lowest = random_corner[0] < contiguous_corner[0] ? random_corner : contiguous_corner#TODO-could use enumerable#min/max?
      heighest = random_corner[0] > contiguous_corner[0] ? random_corner : contiguous_corner
      p1 = [lowest[0], col]
      p2 = [heighest[0], col.send(symbol, random_offset)]
      
      return if p2[0] >= self.row_count || p2[0] < 0
      return if p2[1] >= self.col_count || p2[1] < 0

      ignore = []
      (lowest[0]..heighest[0]).to_a.each do |row|
        ignore.push([row,col])
      end
    end

    rectangle = Rectangle.new(p1, p2)
    if (check_empty(rectangle, ignore)) then
      build_rectangle(rectangle)
    end
  end

  def check_empty(rectangle, ignore)
    rectangle.iterate do |row, col|
      next if ignore.include?([row, col])
      return false if @rows[row][col] != EMPTY
    end
    return true
  end

  def render()
    return outputter.render(@rows)
  end

  def build_rectangle_in_random_pos
    rows = (0...self.row_count).to_a
    row1 = rows.sample

    row_range_1_start = row1 - self.max_rectangle_height >= 0 ? row1 - self.max_rectangle_height : nil
    row_range_1_end = row1 - self.min_rectangle_height >= 0 ? row1 - self.min_rectangle_height : nil
    row_range_2_start = row1 + self.min_rectangle_height < self.row_count ? row1 + self.min_rectangle_height : nil
    row_range_2_end = row1  + self.max_rectangle_height < self.row_count ? row1 + self.max_rectangle_height : nil
    row_range_1 = row_range_1_start && row_range_1_end ? (row_range_1_start..row_range_1_end).to_a : []
    row_range_2 = row_range_2_start && row_range_2_end ? (row_range_2_start..row_range_2_end).to_a : []
    row_range = row_range_1.concat(row_range_2)
    row2 = row_range.sample

    cols = (0...self.col_count).to_a
    col1 = cols.sample

    col_range_1_start = col1 - self.max_rectangle_width >= 0 ? col1 - self.max_rectangle_width : nil
    col_range_1_end = col1 - self.min_rectangle_width >= 0 ? col1 - self.min_rectangle_width : nil
    col_range_2_start = col1 + self.min_rectangle_width < self.col_count ? col1 + self.min_rectangle_width : nil
    col_range_2_end = col1  + self.max_rectangle_width < self.col_count ? col1 + self.max_rectangle_width : nil
    col_range_1 = col_range_1_start && col_range_1_end ? (col_range_1_start..col_range_1_end).to_a : []
    col_range_2 = col_range_2_start && col_range_2_end ? (col_range_2_start..col_range_2_end).to_a : []
    col_range = col_range = col_range_1.concat(col_range_2)
    col2 = col_range.sample

    raise if row_range.empty?
    raise if col_range.empty?
    
    rectangle = Rectangle.new([row1, col1], [row2, col2])
    build_rectangle(rectangle)
  end

  def run
    reset
    build_rectangle_in_random_pos
    
    iteration_count = 0
    rectangle_count = (self.min_rectangles..self.max_rectangles).to_a.sample
    while @rectangle_count < rectangle_count do
      break if iteration_count >= self.escape_count
      extend_random
      iteration_count += 1
    end
    return render
  end
end
