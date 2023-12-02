module Day02
  CUBE_SET = {
    red: 12,
    green: 13,
    blue: 14
  }.freeze

  class << self
    def part_one(input)
      Input.new(raw_lines: input).lines
        .reject(&:is_impossible?)
        .sum(&:index)
    end

    def part_two(input)
      Input.new(raw_lines: input).lines
        .map(&:max_drawn_by_color)
        .map(&:values)
        .map { |values| values.inject(:*) }
        .sum
    end
  end

  class Input
    attr_reader :raw_lines

    def initialize(raw_lines:)
      @raw_lines = raw_lines
    end

    def lines
      raw_lines.map { |raw_line| Line.new(raw_line:) }.map(&:clean)
    end
  end

  class Line
    attr_reader :raw_line

    def initialize(raw_line:)
      @raw_line = raw_line
    end

    def clean
      game_index, cube_draws_string = raw_line.match(/^Game (\d+): (.*)/).captures

      Game.new(
        index: game_index.to_i,
        cube_draws: cube_draws_string.split(';').map do |str|
          str.scan(/(\d+) (\w+)/).each_with_object({}) { |(count, color), hash| hash[color.to_sym] = count.to_i }
        end
      )
    end
  end

  class Game
    attr_reader :index, :cube_draws

    def initialize(index:, cube_draws:)
      @index = index
      @cube_draws = cube_draws
    end

    def is_impossible?
      !!cube_draws.find { |cube_data| !!cube_data.each_pair.find { |color, count| CUBE_SET[color]&.< count } }
    end

    def max_drawn_by_color
      cube_draws.inject { |memo, cube_data| memo.merge(cube_data) { |_, *counts| counts.max } }
    end
  end
end
