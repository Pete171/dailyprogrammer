require 'minitest/autorun'

class FractionsTest < Minitest::Test
  def setup
    @fractions = Fractions.new
  end

  [
    { input_fractions: [ [1, 6], [3, 10] ], expected_return_value: '7/15' },
    { input_fractions: [ [1, 3], [1, 4], [1, 12] ], expected_return_value: '2/3' },
  ]
  .each.with_index do |data_set, index|
    define_method("test__add_#{index}") do
      actual_return_value = @fractions._add(*data_set[:input_fractions])
      assert_equal(data_set[:expected_return_value], actual_return_value)
    end
  end

  [
    { input_str: <<STR, expected_return_value: [ [1, 6], [3, 10] ] },
1/6
3/10
STR
    { input_str: <<STR, expected_return_value: [ [1, 3], [1, 4], [1, 12] ] },
1/3
1/4
1/12
STR
  ]
  .each.with_index do |test_data, index|
    define_method("test_parse_#{index}") do
      actual_return_value = @fractions.parse(test_data[:input_str])
      assert_equal(test_data[:expected_return_value], actual_return_value)
    end
  end

  [
   { input_str: <<STR, expected_return_value: '89962/5890' },
2/9
4/35
7/34
1/2
16/33
STR
  ]
  .each.with_index do |test_data, index|
    define_method("test_add_#{index}") do
      actual_return_value = @fractions.add(test_data[:input_str])
      assert_equal(test_data[:expected_return_value], actual_return_value)
    end
  end
end

class Fractions
  def add str
    array = parse(str)
    return _add(*array)
  end

  def parse str
    str.chomp.split("\n").map do |fraction|
      raise unless /(\d+)\/(\d+)/ =~ fraction
      $~[1..-1].map(&:to_i)
    end
  end

  def _add *args
    numerators, denominators = args.transpose
    lcm_of_denominators = denominators.reduce { |p, c| p.lcm(c) }
    numerators.map!.with_index do |numerator, index|
      factor = lcm_of_denominators / denominators[index]
      next numerator * factor
    end
    numerator = numerators.reduce(&:+)
    gcd = numerator.gcd(lcm_of_denominators)
    return (numerator / gcd).to_s + '/' + (lcm_of_denominators / gcd).to_s
  end
end
