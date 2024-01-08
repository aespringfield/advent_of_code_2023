module Day14
  DIRECTIONS = {
    north: 'north',
    east: 'east',
    south: 'south',
    west: 'west'
  }.freeze

  DIRECTIONS_ORDER = [
    DIRECTIONS[:north],
    DIRECTIONS[:west],
    DIRECTIONS[:south],
    DIRECTIONS[:east]
  ].freeze

  class << self
    def part_one(input)
      # Transpose input so that columns are rows
      Input.new(raw_lines: input).clean.transpose.map(&:reverse).map do |line|
        segments_by_end_index = {}
        # For each row:
        #   Segment row by # characters, recording start and end index
        line.join.scan(/[^#]+/) do
          end_index = $~.offset(0)[1] - 1
          segments_by_end_index[end_index] = $&
        end
        #   For each segment
        segments_by_end_index.each_pair.map do |end_index, segment|
          #     Count 0 characters (round_rocks_count)
          ((end_index - segment.count('O') + 2)..(end_index + 1))
        end.map(&:sum)

        #     Take range from (segment_end_index - round_rocks_count + 2)..()segment_end_index + 1)--these are the indices + 1 where the round rocks will wind up
        #     Sum that range
      end.flatten.sum

      # Sum rows
    end

    def part_two(input, tilts_count = 1_000_000_000 * 4)
      cache = {}

      # Clean input
      lines = Input.new(raw_lines: input).clean

      # For each i in tilts_count:
      tilts_count.times do |i|
        direction = DIRECTIONS_ORDER[i % DIRECTIONS_ORDER.count]

        # Tilt, get sum
        lines = tilt(lines, direction)

        # Check cache for dir + lines
        if cache[[direction, lines]]

          # If in cache, count tilts between that entry and now
          cycle_length = i - cache[[direction, lines]]

          # Return total load in cycle where remaining tilts % cycle length is cycle index
          cycle_index = (tilts_count - (i + 1)) % cycle_length
          cycle_stage_lines = cache.key(cycle_index + cache[[direction, lines]])[1]

          return calculate_total_load(cycle_stage_lines)
        else
          # If not in cache, add to cache, where key is dir + lines and value is index
          cache[[direction, lines]] = i
        end
      end
    end

    def calculate_total_load(lines)
      lines.map.with_index { |line, i| line.count('O') * (lines.count - i) }.sum
    end

    def tilt(lines, direction)
      cache = {}

      lines.then do |original_lines|
        # Transpose if dir is north or south
        [DIRECTIONS[:north], DIRECTIONS[:south]].include?(direction) ? original_lines.transpose.map(&:reverse) : original_lines
      end.map do |line|
        segments_by_end_index = {}
        # For each row:
        #   Segment row by # characters, recording start and end index
        line.join.scan(/#+|[^#]+/) do
          end_index = $~.offset(0)[1] - 1
          segments_by_end_index[end_index] = $&
        end

        segments = segments_by_end_index.each_pair.sort_by(&:first).map { |pair| pair[1] }

        segments.flat_map do |segment|
          # Check cache for segment
          next cache[[direction, segment]] if cache[[direction, segment]]

          result = if segment.match(/^#+$/)
            segment.split('')
          else
            rolling_rock_count = segment.scan(/O/)&.count
            nothing_count = segment.length - rolling_rock_count

            if [DIRECTIONS[:south], DIRECTIONS[:west]].include?(direction)
              Array.new(rolling_rock_count, 'O') + Array.new(nothing_count, '.')
            else
              Array.new(nothing_count, '.') + Array.new(rolling_rock_count, 'O')
            end
          end

          cache[[direction, segment]] = result
          result
        end
      end.then do |new_lines|
        # Transpose back if dir is north or south
        [DIRECTIONS[:north], DIRECTIONS[:south]].include?(direction) ? new_lines.transpose.reverse : new_lines
      end
    end
  end

  class Input
    def initialize(raw_lines:)
      @raw_lines = raw_lines
    end

    def clean
      raw_lines.map { |line| line.split('') }
    end

    private

    attr_reader :raw_lines
  end
end
