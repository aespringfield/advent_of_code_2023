module Day10
  # [row_offset, column_offset]
  PIPE_DIRECTIONS = {
    '|' => [[1, 0], [-1, 0]],
    '-' => [[0, 1], [0, -1]],
    'L' => [[-1, 0], [0, 1]],
    'J' => [[-1, 0], [0, -1]],
    '7' => [[1, 0], [0, -1]],
    'F' => [[0, 1], [1, 0]]
  }.freeze

  class << self
    def part_one(input)
      start_coordinates, grid = Input.new(raw_lines: input).clean.values_at(:start_coordinates, :grid)
      first_pipe_coordinates, last_pipe_coordinates = adjacent_pipe_coordinates(start_coordinates, grid)
      first_pipe_row_index, first_pipe_column_index = first_pipe_coordinates
      start_row_index, start_column_index = start_coordinates
      first_pipe = grid[first_pipe_row_index][first_pipe_column_index]
      first_input_offsets = output_offsets(
        [first_pipe_row_index - start_row_index, first_pipe_column_index - start_column_index],
        first_pipe
      )

      [
        start_coordinates,
        *pipe_loop_coordinates(first_input_offsets, first_pipe_coordinates, last_pipe_coordinates, grid)
      ].count / 2
    end

    def part_two(input)
      raise NotImplementedError
    end

    def output_offsets(input_offsets, pipe)
      PIPE_DIRECTIONS[pipe].find { |offsets| offsets != input_offsets.map { |offset| -offset } }
    end

    def pipe_loop_coordinates(input_offsets, pipe_coordinates, last_pipe_coordinates, grid)
      coordinates = [pipe_coordinates]
      next_input_offsets = input_offsets
      next_pipe_coordinates = pipe_coordinates

      while next_pipe_coordinates != last_pipe_coordinates do
        next_pipe_coordinates = next_pipe_coordinates.zip(next_input_offsets).map(&:sum)
        next_pipe = grid[next_pipe_coordinates[0]][next_pipe_coordinates[1]]
        next_input_offsets = output_offsets(next_input_offsets, next_pipe)

        coordinates << next_pipe_coordinates
      end

      coordinates
    end

    def adjacent_pipe_coordinates(start_coordinates, grid)
      start_row_index, start_column_index = start_coordinates
      [
        [
          start_row_index - 1,
          start_column_index
        ],
        [
          start_row_index,
          start_column_index - 1
        ],
        [
          start_row_index + 1,
          start_column_index
        ],
        [
          start_row_index,
          start_column_index + 1
        ],
      ].reject { |row_index, column_index| row_index < 0 || column_index < 0 }
      .select do |row_index, column_index|
        character = grid[row_index]&.[](column_index)

        PIPE_DIRECTIONS[character]&.any? do |row_offset, column_offset|
          [row_index - start_row_index, column_index - start_column_index] == [row_offset, column_offset].map { |offset| -offset }
        end
      end
    end
  end

  class Input
    def initialize(raw_lines:)
      @raw_lines = raw_lines
    end

    def clean
      start_coordinates = nil
      grid = raw_lines.each_with_object({}).with_index do |(line, hash), row_index|
        line.split('').map.with_index do |character, column_index|
          start_coordinates = [row_index, column_index] if character == 'S'

          hash[row_index] ||= {}
          hash[row_index][column_index] = character
        end
      end

      {
        start_coordinates:,
        grid:
      }
    end

    private

    attr_reader :raw_lines
  end
end
