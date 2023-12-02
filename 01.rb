require 'numbers_in_words'

module Day01
  class << self
    def part_one(input)
      input.map do |line|
        matches = line.scan(/\d/)
        "#{matches.first}#{matches.last}".to_i
      end.sum
    end

    def part_two(input)
      input.map do |line|
        regex = /(?=(#{(0..9).map { |num| NumbersInWords.in_words(num) }.join('|')}|\d))/
        matches = line.scan(regex).flatten
        "#{NumbersInWords.in_numbers(matches.first).to_i}#{NumbersInWords.in_numbers(matches.last)}".to_i
      end.sum
    end
  end
end
