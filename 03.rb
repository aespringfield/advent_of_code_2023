module Day03
  class << self
    SYMBOLS = %w[* $ # & = / - + % @].freeze

    def part_one(input)
      Input.new(raw_lines: input, symbols: SYMBOLS)
        .clean
        .numbers_adjacent_to_symbols
        .map(&:value)
        .sum
    end

    def part_two(input)
      Input.new(raw_lines: input, symbols: ['*'])
        .clean
        .number_pairs_connected_by_symbol
        .map { |number_pairs| number_pairs&.inject(&:*) }
        .sum
    end
  end

  class Input
    attr_reader :raw_lines, :symbols

    def initialize(raw_lines:, symbols:)
      @raw_lines = raw_lines
      @symbols = symbols
    end

    def clean
      number_positions, symbol_positions = raw_lines.each_with_object({ number_positions: {}, symbol_positions: {} }).with_index do |(line, hash),line_index|
        hash[:number_positions] = { **hash[:number_positions], **number_positions_from_line(line, line_index) }
        hash[:symbol_positions] = { **hash[:symbol_positions], **symbol_positions_from_line(line, line_index) }
      end.values_at(:number_positions, :symbol_positions)

      Schematic.new(
        number_positions:,
        symbol_positions:
      )
    end

    private

    def symbol_regex
      /#{symbols.map { |symbol| "\\#{symbol}" }.join('|')}/
    end

    def number_positions_from_line(raw_line, line_index)
      number_positions = {}

      raw_line.scan(/\d+/) do |capture|
        number = capture.to_i
        number_start_index, number_end_index = $~.offset(0)

        number_positions[line_index] ||= []
        number_positions[line_index] << SchematicNumber.new(
          value: number,
          line_index:,
          start_column_index: number_start_index,
          end_column_index: number_end_index # end index from offset is exclusive
        )
      end

      number_positions
    end

    def symbol_positions_from_line(raw_line, line_index)
      symbol_positions = {}

      raw_line.scan(symbol_regex) do
        symbol_start_index, _ = $~.offset(0)
        symbol_positions[line_index] ||= []
        symbol_positions[line_index] << symbol_start_index
      end

      symbol_positions
    end
  end

  class Schematic
    attr_reader :number_positions, :symbol_positions

    DIAGONAL_DISTANCE = 1

    def initialize(number_positions:, symbol_positions:)
      @number_positions = number_positions
      @symbol_positions = symbol_positions
    end

    def numbers_adjacent_to_symbols
      numbers.select do |number|
        has_symbol_to_left?(number) || has_symbol_to_right?(number) || has_symbol_above?(number) || has_symbol_below?(number)
      end
    end

    def number_pairs_connected_by_symbol
      symbol_positions.each_pair.with_object([]) do |(row_index, column_indices), number_sets|
        column_indices.each do |gear_index|
          number_sets << [
            # Vertically adjacent numbers (above), including diagonals. If row index is 0, then no numbers can be above,
            # and we don't want it to wrap around to the bottom of the schematic, so we just pass an empty array
            *(row_index - 1 >= 0 ? numbers_vertically_adjacent_to_index(row_index - 1, gear_index) : []),
            # Vertically adjacent numbers (below), including diagonals
            *numbers_vertically_adjacent_to_index(row_index + 1, gear_index),
            # Horizontally adjacent numbers (left & right), if any
            *numbers_horizontally_adjacent_to_index(row_index, gear_index)
          ]
        end
      end.select { |number_set| number_set.length == 2 }
    end

    private

    def numbers
      number_positions.values.flatten
    end

    def has_symbol_to_left?(number)
      symbol_at_index?(number.line_index, number.start_column_index - 1)
    end

    def has_symbol_to_right?(number)
      symbol_at_index?(number.line_index, number.end_column_index)
    end

    # Includes diagonal left + right
    def has_symbol_below?(number)
      symbol_in_range?(number.line_index + 1, number.start_column_index - 1, number.end_column_index)
    end

    # Includes diagonal left + right
    def has_symbol_above?(number)
      return false unless number.line_index - 1 >= 0

      symbol_in_range?(number.line_index - 1, number.start_column_index - 1, number.end_column_index)
    end

    def symbol_at_index?(line_index, index)
      !!symbol_positions[line_index]&.bsearch { |symbol_index| index <=> symbol_index }
    end

    def number_at_index(line_index, index, &block)
      number_positions[line_index]
        &.bsearch { |number| index <=> block.call(number) }
        &.then(&:value)
    end

    def symbol_in_range?(line_index, start_index, end_index)
      !!symbol_positions[line_index]
        &.bsearch { |index| index >= start_index }
        &.then { |lowest_symbol_index_in_range| lowest_symbol_index_in_range&.<=(end_index) }
    end

    def numbers_vertically_adjacent_to_index(line_index, index)
      numbers = number_positions[line_index]
      # Optimization to avoid iterating over the index ranges of numbers that are too far away
      relevant_numbers = relevant_array_section(numbers, index, ->(number) { number.end_column_index }, ->(number) { number.start_column_index } )

      # Iterate through numbers, selecting ones where gear index is in range from number start index - 1 to number end index
      relevant_numbers
        &.select { |number| ((number.start_column_index - DIAGONAL_DISTANCE)..number.end_column_index).include?(index) }
        &.map(&:value) || []
    end

    def numbers_horizontally_adjacent_to_index(line_index, index)
      [
        number_at_index(line_index, index - 1) { |number| number.end_column_index - 1 }, # subtract 1 to account for end index being exclusive
        number_at_index(line_index, index + 1) { |number| number.start_column_index }
      ].compact
    end

    # Find array slice that includes only numbers that end within diagonal distance to the left (aka 1, for the diagonals)
    # of the gear index, and only numbers that start within diagonal distance to the right of the gear index
    # (performance optimization to avoid iterating over the entire array)
    def relevant_array_section(array, index, start_index_parser, end_index_parser)
      return unless array

      start_index = index > 0 ? inclusion_start_index(array, index, &start_index_parser) : 0
      end_index = index < array.length - 1 ? inclusion_end_index(array, index, &end_index_parser) : index

      array.slice(start_index || 0, end_index ? end_index + 1 : array.length)
    end

    # inclusion start index = index of first number where end index >= gear proximity minimum (gear_index - 1)
    def inclusion_start_index(array, index, &block)
      array&.bsearch_index { |element| block.call(element) >= index - DIAGONAL_DISTANCE } # subtract column_distance to account for the diagonal
    end

    # inclusion end index = index of first number where start index > gear proximity minimum (gear_index + 1)
    def inclusion_end_index(array, index, &block)
      array&.bsearch_index { |element| block.call(element) > index + DIAGONAL_DISTANCE } # add column_distance to account for the diagonal
    end
  end

  class SchematicNumber
    attr_reader :value, :line_index, :start_column_index, :end_column_index

    def initialize(value:, line_index:, start_column_index:, end_column_index:)
      @value = value
      @line_index = line_index
      @start_column_index = start_column_index
      @end_column_index = end_column_index
    end
  end
end
