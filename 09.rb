module Day09
  class << self
    def part_one(input)
      Input.new(raw_lines: input).clean.map do |history|
        sequences_for_history(history).reverse.map(&:last).sum
      end.sum
    end

    def part_two(input)
      Input.new(raw_lines: input).clean.map do |history|
        sequences_for_history(history).reverse.map(&:first).each_with_object([0]) do |value, memo|
          memo << value - memo.last
        end.last
      end.sum
    end

    def sequences_for_history(history)
      return [history] if history.all? { |element| element == 0 }

      new_history = history.each_cons(2).to_a.map { |a, b| b - a }
      [history, *sequences_for_history(new_history)]
    end
  end

  class Input
    def initialize(raw_lines:)
      @raw_lines = raw_lines
    end

    def clean
      raw_lines.map { |line| line.split(' ').map(&:to_i) }
    end

    private

    attr_reader :raw_lines
  end
end
