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
      number_positions, symbol_coordinates = raw_lines.each_with_object({ number_positions: {}, symbol_coordinates: {} }).with_index do |(line, hash),line_index|
        hash[:number_positions] = { **hash[:number_positions], **number_positions_from_line(line, line_index) }
        hash[:symbol_coordinates][line_index] = symbol_coordinates_for_line(line)
      end.values_at(:number_positions, :symbol_coordinates)

      Schematic.new(
        number_positions:,
        symbol_coordinates:
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

    def symbol_coordinates_for_line(raw_line)
      symbol_coordinates = {}

      raw_line.scan(symbol_regex) do |capture|
        column_index, _ = $~.offset(0)
        symbol_coordinates[column_index] = capture
      end

      symbol_coordinates
    end
  end

  class Schematic
    attr_reader :number_positions, :symbol_coordinates

    DIAGONAL_DISTANCE = 1

    def initialize(number_positions:, symbol_coordinates:)
      @number_positions = number_positions
      @symbol_coordinates = symbol_coordinates
    end

    def numbers_adjacent_to_symbols
      numbers.select do |number|
        has_symbol_to_left?(number) || has_symbol_to_right?(number) || has_symbol_above?(number) || has_symbol_below?(number)
      end
    end

    def number_pairs_connected_by_symbol
      symbol_coordinates.keys.each_with_object([]) do |row_index, number_sets|
        symbol_coordinates[row_index].keys.each do |column_index|
          number_sets << [
            *numbers_above_index(row_index, column_index),
            *numbers_below_index(row_index, column_index),
            *numbers_to_the_left_and_right_of_index(row_index, column_index)
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
      !symbol_coordinates[line_index]&.[](index).nil?
    end

    def number_at_index(line_index, index, &block)
      number_positions[line_index]
        &.bsearch { |number| index <=> block.call(number) }
        &.then(&:value)
    end

    def symbol_in_range?(line_index, start_index, end_index)
      !(start_index..end_index).to_a.find do |column_index|
        symbol_coordinates[line_index]&.[](column_index)
      end.nil?
    end

    # Vertically adjacent numbers (above), including diagonals. If row index is 0, then no numbers can be above,
    # and we don't want it to wrap around to the bottom of the schematic, so we just return an empty array
    def numbers_above_index(line_index, index)
      line_index - 1 >= 0 ? numbers_vertically_adjacent_to_index(line_index - 1, index) : []
    end

    # Vertically adjacent numbers (below), including diagonals.
    def numbers_below_index(line_index, index)
      numbers_vertically_adjacent_to_index(line_index + 1, index)
    end

    def numbers_vertically_adjacent_to_index(line_index, index)
      numbers = number_positions[line_index]
      # Optimization to avoid iterating over the index ranges of numbers that are too far away
      relevant_numbers = relevant_array_section(numbers, index, ->(number) { number.start_column_index }, ->(number) { number.end_column_index } )

      # Iterate through numbers, selecting ones where gear index is in range from number start index - 1 to number end index
      relevant_numbers
        &.select { |number| ((number.start_column_index - DIAGONAL_DISTANCE)..number.end_column_index).include?(index) }
        &.map(&:value) || []
    end

    def numbers_to_the_left_and_right_of_index(line_index, index)
      [
        number_at_index(line_index, index - 1) { |number| number.end_column_index - 1 }, # subtract 1 to account for end index being exclusive
        number_at_index(line_index, index + 1) { |number| number.start_column_index }
      ].compact
    end

    # Find array slice that includes only numbers that end within diagonal distance to the left (aka 1)
    # of the gear index, and only numbers that start within diagonal distance to the right of the gear index
    # (performance optimization to avoid iterating over the entire array)
    #
    # start_index_parser and end_index_parser are procs that take an element (in practice, a number)
    # and return the start or end index of that element. Note that start_index_parser will be passed to the method
    # that finds the end index, and vice versa. This is because we care about the end index of the number when comparing
    # finding elements that are out of range to the left of the index, and the start index of the number when
    # finding elements that are out of range to the right of the index.
    def relevant_array_section(array, index, start_index_parser, end_index_parser)
      return unless array

      start_index = index > 0 ? inclusion_start_index(array, index, &end_index_parser) : 0
      end_index = index < array.length - 1 ? inclusion_end_index(array, index, &start_index_parser) : index

      array.slice(start_index || 0, end_index ? end_index + 1 : array.length)
    end

    # inclusion start index = index of first number where end index >= gear proximity minimum (gear_index - 1)
    def inclusion_start_index(array, index, &block)
      array&.bsearch_index { |element| block.call(element) >= index - DIAGONAL_DISTANCE }
    end

    # inclusion end index = index of first number where start index > gear proximity minimum (gear_index + 1)
    def inclusion_end_index(array, index, &block)
      array&.bsearch_index { |element| block.call(element) > index + DIAGONAL_DISTANCE }
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
