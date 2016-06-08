#https://www.reddit.com/r/dailyprogrammer/comments/3aqvjn/20150622_challenge_220_easy_mangling_sentences/

require 'minitest/autorun'

class MangleTest < Minitest::Test
  [
    {
       input: "This challenge doesn't seem so hard.",
       expected_output: "Hist aceeghlln denos't eems os adhr.",
    },
    {
      input: "time-worn",
     expected_output: "eimn-ortw",
    },
    {
     input: "There are more things between heaven and earth, Horatio, than are dreamt of in your philosophy.",
     expected_output: "Eehrt aer emor ghinst beeentw aeehnv adn aehrt, Ahioort, ahnt aer ademrt fo in oruy hhilooppsy.",
    }
  ]
  .each.with_index do |hash, index|
    define_method("test_mangle_with_data_set_#{index}") do
      actual_output = Mangle.new.mangle(hash.fetch(:input))
      assert_equal(hash.fetch(:expected_output), actual_output)
    end
  end
end

class Mangle
  def mangle(input)
    capital_indexes = []
    input.each_char.with_index do |char, index|
      capital_indexes.push index if /[A-Z]/.match(char)
    end

    input = input.gsub /\S+/ do |word|
      punctuation = /[^A-Za-z]/.match(word) || []
      punctuation_hash = {}

      (0...punctuation.size).to_a.each do |index|
        punctuation_hash[punctuation.begin(index)] = punctuation[index]
      end

      word = word.downcase.gsub(/[^A-Za-z]/, '').chars.sort.join

      punctuation_hash.each do |key, value|
        word[key, 0] = value
      end

      next word
    end

    capital_indexes.each do |index|
      input[index] = input[index].upcase
    end

    return input
  end
end
