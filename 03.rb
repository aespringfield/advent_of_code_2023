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
      number_coordinates, symbol_coordinates = raw_lines.each_with_object({ number_coordinates: {}, symbol_coordinates: {} }).with_index do |(line, hash),line_index|
        hash[:number_coordinates][line_index] = number_coordinates_for_line(line, line_index)
        hash[:symbol_coordinates][line_index] = symbol_coordinates_for_line(line)
      end.values_at(:number_coordinates, :symbol_coordinates)

      Schematic.new(
        number_coordinates:,
        symbol_coordinates:
      )
    end

    private

    def symbol_regex
      /#{symbols.map { |symbol| "\\#{symbol}" }.join('|')}/
    end

    def number_coordinates_for_line(raw_line, line_index)
      number_coordinates = {}

      raw_line.scan(/\d+/) do |capture|
        number = capture.to_i
        number_start_index, number_end_index = $~.offset(0)

        schematic_number = SchematicNumber.new(
          value: number,
          line_index:,
          start_column_index: number_start_index,
          end_column_index: number_end_index # end index from offset is exclusive
        )

        (number_start_index..(number_end_index - 1)).each do |column_index|
          number_coordinates[column_index] = schematic_number
        end
      end

      number_coordinates
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
    attr_reader :number_coordinates, :symbol_coordinates

    DIAGONAL_DISTANCE = 1

    def initialize(number_coordinates:, symbol_coordinates:)
      @number_coordinates = number_coordinates
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
      number_coordinates.values.map { |line_hash| line_hash.values.uniq(&:start_column_index) }.flatten
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

    def number_at_index(line_index, index)
      number_coordinates[line_index]&.[](index)&.value
    end

    def symbol_in_range?(line_index, start_index, end_index)
      !(start_index..end_index).to_a.find do |column_index|
        symbol_coordinates[line_index]&.[](column_index)
      end.nil?
    end

    # Vertically adjacent numbers (above), including diagonals.
    def numbers_above_index(line_index, index)
      numbers_vertically_adjacent_to_index(line_index - 1, index)
    end

    # Vertically adjacent numbers (below), including diagonals.
    def numbers_below_index(line_index, index)
      numbers_vertically_adjacent_to_index(line_index + 1, index)
    end

    def numbers_vertically_adjacent_to_index(line_index, index)
      return [] if line_index < 0

      ((index - 1)..(index + 1)).map do |i|
        next if i < 0

        number_coordinates[line_index]&.[](i)
      end.compact.uniq(&:start_column_index).map(&:value)
    end

    def numbers_to_the_left_and_right_of_index(line_index, index)
      [
        number_at_index(line_index, index - 1),
        number_at_index(line_index, index + 1)
      ].compact
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
