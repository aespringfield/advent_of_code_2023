module Day12
  class << self
    def part_one(input)
      Input.new(raw_lines: input).clean.map do |row|
        springs_options_count(row[:springs], row[:contiguous_damaged_springs])
      end.sum
    end

    def part_two(input)
      Input.new(raw_lines: input).clean.map do |row|
        springs_options_count(([row[:springs]] * 5).join('?'), ([row[:contiguous_damaged_springs]] * 5).flatten)
      end.sum
    end

    def springs_options_count(springs, runs)
      return 1 if springs.empty? && runs.empty?
      return 0 if springs.empty? && !runs.empty?

      @cache ||= {}
      return @cache[[springs, runs]] if @cache[[springs, runs]]

      result = 0

      if %w[. ?].include? springs[0]
        springs_index_offset = springs.slice(1, springs.length).index(/[^\.]/) || 0 # Skip repeated .
        result += springs_options_count(springs[(1 + springs_index_offset)..-1], runs)
      end

      if %w[# ?].include? springs[0]
        return result if runs.empty?
        return result if springs.length != runs[0] && !(%w[. ?].include? springs[runs[0]])
        return result if springs.length < runs.sum + runs.length - 1
        return result if springs.index('.')&.<(runs[0])

        springs_index_offset = springs.length > runs[0] ? 1 : 0
        result += springs_options_count(springs[(runs[0] + springs_index_offset)..-1], runs[1..-1])
      end

      @cache[[springs, runs]] = result

      result
    end
  end

  class Input
    def initialize(raw_lines:)
      @raw_lines = raw_lines
    end

    def clean
      raw_lines.map do |line|
        springs, contiguous_damaged_springs_string = line.split(' ')
        contiguous_damaged_springs = contiguous_damaged_springs_string.split(',').map(&:to_i)
        {
          springs:,
          contiguous_damaged_springs:
        }
      end
    end

    private

    attr_reader :raw_lines
  end
end
