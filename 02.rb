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
        .reject { |data| !!data[:cubes].find { |cube_data| !!cube_data.each_pair.find { |color, count| CUBE_SET[color]&.< count } } }
        .sum { |data| data[:game] }
    end

    def part_two(input)
      input
        .map { |line| clean(line)[:cubes].inject { |memo, cube_data| memo.merge(cube_data) { |_, *counts| counts.max } }.values.inject(:*) }
        .sum
    end

    private

    def clean(line)
      game_index, cubes_string = line.match(/^Game (\d+): (.*)/).captures

      {
        game: game_index.to_i,
        cubes: cubes_string.split(';').map do |str|
          str.scan(/(\d+) (\w+)/).each_with_object({}) { |(count, color), hash| hash[color.to_sym] = count.to_i }
        end
      }
    end
  end
end
