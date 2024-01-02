module Day14
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

    def part_two(input)
      raise NotImplementedError
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
