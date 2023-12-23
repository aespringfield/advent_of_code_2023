module Day10
  # [row_offset, column_offset]
  PIPE_OFFSETS = {
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
      pipe_loop(start_coordinates, grid).count / 2
    end

    def part_two(input)
      start_coordinates, grid = Input.new(raw_lines: input).clean.values_at(:start_coordinates, :grid)
      pipe_loop_hash = pipe_loop(start_coordinates, grid).each_with_object({}) do |pipe_hash, memo|
        (row_index, column_index), pipe = pipe_hash.values_at(:coordinates, :pipe)
        memo[row_index] ||= {}
        memo[row_index][column_index] = pipe
      end

      grid.each_pair.map do |row_index, hash|
        hash.each_pair.each_with_object({ num_enclosed_tiles: 0, loop_open: false, partial_vertical: nil }) do |(column_index, _), memo|
          pipe_in_loop = pipe_loop_hash[row_index]&.[](column_index)
          memo[:num_enclosed_tiles] = memo[:num_enclosed_tiles] + 1 if pipe_in_loop.nil? && memo[:loop_open]
          next unless pipe_in_loop && pipe_in_loop != '-'

          (memo[:loop_open] = !memo[:loop_open]; next) if pipe_in_loop == '|'
          (memo[:partial_vertical] = pipe_in_loop; next) if memo[:partial_vertical].nil?

          memo[:loop_open] = !memo[:loop_open] if [%w[F J], %w[7 L]].include?([memo[:partial_vertical], pipe_in_loop].sort)
          memo[:partial_vertical] = nil
        end[:num_enclosed_tiles]
      end.sum
    end

    def pipe_loop(start_coordinates, grid)
      first_pipe_coordinates, last_pipe_coordinates = adjacent_pipe_coordinates(start_coordinates, grid)
      [
        {
          coordinates: start_coordinates,
          pipe: pipe_at_coordinates(start_coordinates, first_pipe_coordinates, last_pipe_coordinates)
        },
        *pipe_loop_after_start(
          first_input_offsets(first_pipe_coordinates, start_coordinates, grid),
          first_pipe_coordinates,
          last_pipe_coordinates,
          grid
        )
      ]
    end

    def pipe_at_coordinates(pipe_coordinates, adjacent_pipe_coordinates1, adjacent_pipe_coordinates2)
      offset1 = adjacent_pipe_coordinates1.zip(pipe_coordinates).map { |indices| indices.inject(&:-) }
      offset2 = adjacent_pipe_coordinates2.zip(pipe_coordinates).map { |indices| indices.inject(&:-) }

      PIPE_OFFSETS.keys.find { |pipe| PIPE_OFFSETS[pipe].sort == [offset1, offset2].sort }
    end

    def first_input_offsets(first_pipe_coordinates, start_coordinates, grid)
      first_pipe_row_index, first_pipe_column_index = first_pipe_coordinates
      start_row_index, start_column_index = start_coordinates
      first_pipe = grid[first_pipe_row_index][first_pipe_column_index]
      output_offsets(
        [first_pipe_row_index - start_row_index, first_pipe_column_index - start_column_index],
        first_pipe
      )
    end

    def output_offsets(input_offsets, pipe)
      PIPE_OFFSETS[pipe].find { |offsets| offsets != input_offsets.map { |offset| -offset } }
    end

    def pipe_loop_after_start(input_offsets, pipe_coordinates, last_pipe_coordinates, grid)
      coordinates = [{
        coordinates: pipe_coordinates,
        pipe: grid[pipe_coordinates[0]][pipe_coordinates[1]]
      }]
      next_input_offsets = input_offsets
      next_pipe_coordinates = pipe_coordinates

      while next_pipe_coordinates != last_pipe_coordinates do
        next_pipe_coordinates = next_pipe_coordinates.zip(next_input_offsets).map(&:sum)
        next_pipe = grid[next_pipe_coordinates[0]][next_pipe_coordinates[1]]
        next_input_offsets = output_offsets(next_input_offsets, next_pipe)

        coordinates << {
          coordinates: next_pipe_coordinates,
          pipe: next_pipe
        }
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

        start_row_offset = row_index - start_row_index
        start_column_offset = column_index - start_column_index

        PIPE_OFFSETS[character]&.any? do |row_offset, column_offset|
          [start_row_offset, start_column_offset] == [row_offset, column_offset].map { |offset| -offset }
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
