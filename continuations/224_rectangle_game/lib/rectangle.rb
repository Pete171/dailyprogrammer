class Rectangle
  attr_reader :p1, :p2

  def initialize(p1, p2)
    @p1 = p1
    @p2 = p2
    raise if p1[0] == p2[0]
    raise if p1[1] == p2[1]
    p1[0], p2[0] = p2[0], p1[0] if p1[0] > p2[0]
    p1[1], p2[1] = p2[1], p1[1] if p1[1] > p2[1]
  end

  def iterate
    raise "Block required" if !block_given?
    p1[0].upto(p2[0]) do |row|
      p1[1].upto(p2[1]) do |col|
        yield row, col
      end
    end
  end
end
