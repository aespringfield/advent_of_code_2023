module Day02
  class << self
    CUBE_SET = {
      red: 12,
      green: 13,
      blue: 14
    }.freeze

    def part_one(input)
      input
        .map { |line| clean(line) }
        .reject { |data| !!data[:cubes].find { |cube_data| is_impossible?(cube_data) } }
        .sum { |data| data[:game] }
    end

    def part_two(input)
      input
        .map { |line| clean(line) }
        .map { |data| counts_by_color(data[:cubes]).values.map(&:max).inject(:*) }
        .sum
    end

    private

    def clean(line)
      {
        game: game_index(line),
        cubes: line.split(':')[1].split(';').map do |str|
          cube_data(str)
        end
      }
    end

    def is_impossible?(cube_data)
      !!cube_data.each_pair.find do |color, count|
        CUBE_SET[color].nil? || count > CUBE_SET[color]
      end
    end

    def game_index(line)
      line.match(/^Game (\d+):/).captures.first.to_i
    end

    def cube_data(str)
      str.scan(/(\d+) (\w+)/).each_with_object({}) do |(count, color), hash|
        hash[color.to_sym] = count.to_i
      end
    end

    def counts_by_color(cubes)
      cubes.each_with_object({}) do |cube_data, hash|
        cube_data.each_pair do |color, count|
          hash[color] ||= []
          hash[color] << count
        end
      end
    end
  end
end
