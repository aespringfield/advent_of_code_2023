module Day03
  class << self
    SYMBOLS = %w[* $ # & = / - + % @].freeze

    def part_one(input)
      symbol_regex = /#{SYMBOLS.map { |symbol| "\\#{symbol}" }.join('|')}/
      numbers = []
      symbol_positions = {}

      input.map.with_index do |line, line_index|
        line.scan(/\d+/) do |capture|
          number = capture.to_i
          number_start_index, number_end_index = $~.offset(0)

          numbers << {
            value: number,
            line_index:,
            start_index: number_start_index,
            end_index: number_end_index # end index from offset is exclusive
          }
        end

        line.scan(symbol_regex) do
          symbol_start_index, _ = $~.offset(0)
          symbol_positions[line_index] ||= []
          symbol_positions[line_index] << symbol_start_index
        end
      end

      numbers.select do |number|
        has_symbol_left = !!symbol_positions[number[:line_index]]&.bsearch { |index|  (number[:start_index] - 1) <=> index }
        has_symbol_right = !!symbol_positions[number[:line_index]]&.bsearch { |index| number[:end_index] <=> index }
        # Includes diagonal left + right
        has_symbol_above = number[:line_index] - 1 >= 0 && !!symbol_positions[number[:line_index] - 1]&.bsearch do |index|
          index >= number[:start_index] - 1
        end.then do |lowest_symbol_index_in_range|
          break unless lowest_symbol_index_in_range

          lowest_symbol_index_in_range <= number[:end_index]
        end
        # Includes diagonal left + right
        has_symbol_below = !!symbol_positions[number[:line_index] + 1]&.bsearch do |index|
          index >= number[:start_index] - 1
        end.then do |lowest_symbol_index_in_range|
          break unless lowest_symbol_index_in_range

          lowest_symbol_index_in_range <= number[:end_index]
        end

        has_symbol_left || has_symbol_right || has_symbol_above || has_symbol_below
      end.map { |number| number[:value] }.sum
    end

    def part_two(input)

    end
  end
end
