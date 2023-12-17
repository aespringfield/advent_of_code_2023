module Day06
  class << self
    def part_one(input)
      Input.new(raw_lines: input).clean.map(&:num_winning_options).inject(&:*)
    end

    def part_two(input)
      Input.new(raw_lines: input).clean(bad_kerning: true).num_winning_options
    end
  end

  class Input
    def initialize(raw_lines:)
      @raw_lines = raw_lines
    end

    def clean(bad_kerning: false)
      if bad_kerning
        Race.new(
          time: bad_kerning_time,
          distance: bad_kerning_distance
        )
      else
        times.zip(distances).map do |time, distance|
          Race.new(
            time:,
            distance:
          )
        end
      end
    end

    private

    def times
      raw_lines[0].match(/Time:(.*)/).captures.first.strip.split(/\s+/).map(&:to_i)
    end

    def distances
      raw_lines[1].match(/Distance:(.*)/).captures.first.strip.split(/\s+/).map(&:to_i)
    end

    def bad_kerning_time
      raw_lines[0].match(/Time:(.*)/).captures.first.strip.split(/\s+/).join.to_i
    end

    def bad_kerning_distance
      raw_lines[1].match(/Distance:(.*)/).captures.first.strip.split(/\s+/).join.to_i
    end

    attr_reader :raw_lines
  end

  class QuadraticEquation
    def self.solve(a:, b:, c:)
      [
        (b * -1 + Math.sqrt(b**2 - 4 * a * c)) / (2 * a),
        (b * -1 - Math.sqrt(b**2 - 4 * a * c)) / (2 * a)
      ].map { |value| value.round(5) }
    end
  end

  class Race
    attr_reader :time, :distance

    def initialize(time:, distance:)
      @time = time
      @distance = distance
    end

    def num_winning_options
      # Solve equation to find button-hold-time that ties record
      # x = time button is held
      # b = time allowed for race (constant)
      # c = distance boat travels
      # c = (a - x) * x
      # c = -x^2 + bx
      # 0 = -x^2 + bx - c
      lower_bound, upper_bound = QuadraticEquation.solve(a: -1, b: time, c: -1 * distance)

      # Find all integers between solutions
      range_start = lower_bound < lower_bound.ceil ? lower_bound.ceil : lower_bound.ceil + 1
      range_end = upper_bound > upper_bound.floor ? upper_bound.floor : upper_bound.floor - 1
      # Count options
      (range_start..range_end).size
    end
  end
end
