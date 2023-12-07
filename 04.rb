module Day04
  class << self
    def part_one(input)
      Input.new(raw_lines: input).clean
        .map(&:point_value)
        .sum
    end

    def part_two(input)
      cards = Input.new(raw_lines: input).clean

      cards.each_with_object(cards.map { |c| [c.index, 1] }.to_h) do |card, copies_by_index|
        ((card.index + 1)..(card.index + card.match_count)).each do |index|
          copies_by_index[index] += copies_by_index[card.index]
        end
      end.values.sum
    end
  end

  class Input
    attr_reader :raw_lines

    def initialize(raw_lines:)
      @raw_lines = raw_lines
    end

    def clean
      raw_lines.map do |raw_line|
        index_string, card_string = raw_line.split(':')
        index = index_string.match(/Card\s+(\d+)/).captures.first.to_i
        numbers, winning_numbers = card_string.split('|').map { |str| str.strip.split(' ') }
        Card.new(index:, numbers:, winning_numbers:)
      end
    end
  end

  class Card
    attr_reader :index, :numbers, :winning_numbers
    attr_accessor :copies

    def initialize(index:, numbers:, winning_numbers:)
      @index = index
      @numbers = numbers
      @winning_numbers = winning_numbers
      @copies = 1
    end

    def point_value
      match_count > 0 ? 2**(match_count - 1) : 0
    end

    def match_count
      @match_count ||= (numbers & winning_numbers).count
    end

    def card_indices_won
      ((index + 1)..(index + match_count)).to_a
    end
  end
end
