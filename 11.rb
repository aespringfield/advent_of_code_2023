module Day11
  class << self
    def part_one(input)
      galaxy_distances_sum(input, 2)
    end

    def part_two(input)
      galaxy_distances_sum(input, 1_000_000)
    end

    def galaxy_distances_sum(input, expansion_factor)
      galaxies = Input.new(raw_lines: input, expansion_factor:).clean

      galaxies
        .keys
        .combination(2)
        .map { |galaxy, other_galaxy| galaxies[other_galaxy].zip(galaxies[galaxy]).map { |indices| indices.inject(&:-).abs }.sum }
        .sum
    end
  end

  class Input
    def initialize(raw_lines:, expansion_factor:)
      @raw_lines = raw_lines
      @expansion_factor = expansion_factor
    end

    def clean
      expanded_galaxies
    end

    private

    def expanded_galaxies
      unexpanded_galaxies.each_pair.with_object({}) do |(galaxy, coordinates), hash|
        galaxy_row_index, galaxy_column_index = coordinates
        hash[galaxy] = [
          galaxy_row_index + (expansion_factor - 1) * (Set[*0..(galaxy_row_index - 1)] & row_indices_with_no_galaxies).count,
          galaxy_column_index + (expansion_factor - 1) * (Set[*0..(galaxy_column_index - 1)] & column_indices_with_no_galaxies).count
        ]
      end
    end

    def unexpanded_galaxies
      @unexpanded_galaxies ||= unexpanded_grid.each_with_object({ galaxies: {}, next_galaxy_number: 1 }).with_index do |(row, hash), row_index|
        row.each_with_index do |element, column_index|
          next if element == '.'

          hash[:galaxies][hash[:next_galaxy_number]] = [row_index, column_index]
          hash[:next_galaxy_number] = hash[:next_galaxy_number] + 1
        end
      end[:galaxies]
    end

    def unexpanded_grid
      @unexpanded_grid ||= raw_lines.map { |line| line.split('') }
    end

    def row_indices_with_no_galaxies
     @row_indices_with_no_galaxies ||= unexpanded_grid.each_with_index.with_object(Set.new) do |(line, index), row_indices_set|
       row_indices_set.add(index) unless line.include?('#')
     end
    end

    def column_indices_with_no_galaxies
      @column_indices_with_no_galaxies ||= unexpanded_grid.transpose.each_with_index.with_object(Set.new) do |(line, index), column_indices_set|
        column_indices_set.add(index) unless line.include?('#')
      end
    end

    attr_reader :raw_lines, :expansion_factor
  end
end
