module Day07
  CARDS = %w[2 3 4 5 6 7 8 9 T J Q K A].freeze
  CARDS_WITH_JOKERS = %w[J 2 3 4 5 6 7 8 9 T Q K A].freeze
  HAND_TYPES = [
    [1,1,1,1,1],  # High card
    [2,1,1,1],    # One pair
    [2,2,1],      # Two pair
    [3,1,1],      # Three of a kind
    [3,2],        # Full house
    [4,1],        # Four of a kind
    [5],          # Five of a kind
  ].freeze


  class << self
    def part_one(input)
      Input.new(raw_lines: input).clean.sort_by do |hash|
        [
          HAND_TYPES.index(hash[:hand].tally.values.sort.reverse),
          CARDS.index(hash[:hand][0]),
          CARDS.index(hash[:hand][1]),
          CARDS.index(hash[:hand][2]),
          CARDS.index(hash[:hand][3]),
          CARDS.index(hash[:hand][4])
        ]
      end.map.with_index { |hash, i| hash[:bid] * (i + 1) }.sum
    end

    def part_two(input)
      Input.new(raw_lines: input).clean.sort_by do |hash|
        card_counts = hash[:hand].tally
        joker_count = card_counts['J'] || 0
        hand_type_without_jokers = card_counts.select { |k, _| k != 'J' }.values.sort.reverse
        highest_card_count = hand_type_without_jokers[0] || 0
        rest_of_card_counts = hand_type_without_jokers[1..-1]
        hand_type = [highest_card_count + joker_count, *rest_of_card_counts]

        [
          HAND_TYPES.index(hand_type),
          CARDS_WITH_JOKERS.index(hash[:hand][0]),
          CARDS_WITH_JOKERS.index(hash[:hand][1]),
          CARDS_WITH_JOKERS.index(hash[:hand][2]),
          CARDS_WITH_JOKERS.index(hash[:hand][3]),
          CARDS_WITH_JOKERS.index(hash[:hand][4])
        ]
      end.map.with_index { |hash, i| hash[:bid] * (i + 1) }.sum
    end
  end

  class Input
    def initialize(raw_lines:)
      @raw_lines = raw_lines
    end

    def clean
      raw_lines.map do |line|
        hand_string, bid_string = line.split(' ')
        {
          hand: hand_string.split(''),
          bid: bid_string.to_i
        }
      end
    end

    private

    attr_reader :raw_lines
  end
end
