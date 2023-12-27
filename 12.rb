require_relative './lib/array_helpers'

module Day12
  class << self
    include ArrayHelpers

    def part_one(input)
      Input.new(raw_lines: input).clean
        .map { |row| options_for_springs(row[:springs], row[:contiguous_damaged_springs]) }
        .sum
    end

    def part_two(input)
      raise NotImplementedError
    end

    def options_for_springs(springs, contiguous_damaged_springs)
      springs_possibilities = get_springs_possibilities(springs)
      count_up_possibilities(springs_possibilities.length)
      springs_possibilities
        .map { |springs_possibility| springs_possibility.join.scan(/#+/).map(&:length) }
        .count { |section_length_possibility| section_length_possibility == contiguous_damaged_springs }
    end

    def get_unknown_indices(springs)
      springs.each_index.select { |i| springs[i] == '?' }
    end

    def get_springs_possibilities(springs)
      unknown_indices = get_unknown_indices(springs)

      %w[# .].repeated_permutation(unknown_indices.length).map do |replacement_possibility|
        springs_possibility = springs.clone

        unknown_indices.each_with_index do |unknown_index, i|
          springs_possibility[unknown_index] = replacement_possibility[i]
        end

        springs_possibility
      end
    end
  end

  class Input
    def initialize(raw_lines:)
      @raw_lines = raw_lines
    end

    def clean
      raw_lines.map do |line|
        spring_string, contiguous_damaged_springs_string = line.split(' ')
        springs = spring_string.split('')
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
