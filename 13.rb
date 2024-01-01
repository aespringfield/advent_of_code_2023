require_relative 'lib/array_helpers'

module Day13
  class << self
    def part_one(input)
      Day13::Input.new(raw_lines: input).clean.map do |set_of_lines|
        possible_vertical_indices = (1..(set_of_lines[0].length - 1)).to_a
        valid_vertical_indices = select_valid_vertical_indices(set_of_lines, possible_vertical_indices)

        raise "There should not be multiple valid vertical indices" if valid_vertical_indices.length > 1

        next (0..(valid_vertical_indices[0] - 1)).size unless valid_vertical_indices.empty?

        possible_horizontal_indices = (1..(set_of_lines.length - 1)).to_a
        valid_horizontal_indices = select_valid_horizontal_indices(set_of_lines, possible_horizontal_indices)

        raise "There should not be multiple valid horizontal indices" if valid_horizontal_indices.length > 1

        (0..(valid_horizontal_indices[0] - 1)).size * 100 unless valid_horizontal_indices.empty?
      end.sum
    end

    def part_two(input)
      Day13::Input.new(raw_lines: input).clean.map do |set_of_lines|
        valid_vertical_indices = select_valid_vertical_indices_with_smudge(set_of_lines)

        raise "There should not be multiple valid vertical indices" if valid_vertical_indices.size > 1

        next (0..(valid_vertical_indices.first - 1)).size unless valid_vertical_indices.empty?

        valid_horizontal_indices = select_valid_horizontal_indices_with_smudge(set_of_lines)

        raise "There should not be multiple valid horizontal indices" if valid_horizontal_indices.size > 1
        if valid_horizontal_indices.empty?
          raise "There's no dang index"
        end

        (0..(valid_horizontal_indices.first - 1)).size * 100
      end.sum
    end

    def select_valid_vertical_indices(lines, possible_indices)
      return possible_indices if lines.empty? || possible_indices.empty?

      select_valid_vertical_indices(
        lines[1..-1],
        possible_indices.select { |possible_index| validate_vertical_index(lines[0], possible_index) }
      )
    end

    def select_valid_horizontal_indices(lines, possible_indices)
      select_valid_vertical_indices(lines.transpose, possible_indices)
    end

    def validate_vertical_index(line, index)
      return false unless index > 0 && index < line.length

      before_index = index - 1
      after_index = index

      while before_index >= 0 && after_index < line.length
        return false unless line[before_index] == line[after_index]

        before_index -= 1
        after_index += 1
      end

      true
    end

    def select_valid_vertical_indices_with_smudge(lines,  line_indices = {}, line_index = 0)
      return possible_indices(line_indices, line_index, false) if lines.empty?

      filtered_possible_indices = possible_indices(line_indices, line_index, true)
      current_possible_indices = filtered_possible_indices.empty? ? Set.new(1..(lines[0].length - 1)) : filtered_possible_indices

      line_smudges_and_symmetrical_indices = possible_smudges_and_symmetrical_indices(lines[0], current_possible_indices)

      line_indices[line_index] = {
        symmetrical_with_smudge_indices: line_smudges_and_symmetrical_indices[:possible_smudges].keys,
        symmetrical_indices: line_smudges_and_symmetrical_indices[:symmetrical_indices]
      }

      select_valid_vertical_indices_with_smudge(lines[1..-1], line_indices, line_index + 1)
    end

    def select_valid_horizontal_indices_with_smudge(lines)
      select_valid_vertical_indices_with_smudge(lines.transpose)
    end

    def possible_indices(line_indices, line_count = line_indices.keys.count, allow_all_symmetrical = true)
      return Set.new if line_indices.empty?

      symmetrical_indices_tally = line_indices.values.map do |line_possible_indices|
        line_possible_indices[:symmetrical_indices]&.to_a
      end.inject(&:+).tally
      symmetrical_with_smudge_indices_tally = line_indices.values&.map do |line_possible_indices|
        line_possible_indices[:symmetrical_with_smudge_indices]&.to_a
      end.inject(&:+).tally

      indices_to_examine = Set.new(
        [
          *symmetrical_with_smudge_indices_tally.select { |_, count| count == 1 }.keys,
          *(allow_all_symmetrical ? symmetrical_indices_tally.select { |_, count| count == line_count }.keys : [])
        ]
      )

      indices_to_examine.each_with_object(Set.new) do |index, set|
        symmetrical_index_count = symmetrical_indices_tally[index] || 0
        symmetrical_with_smudge_index_count = symmetrical_with_smudge_indices_tally[index] || 0
        set.add(index) if (allow_all_symmetrical && symmetrical_index_count == line_count) || (symmetrical_index_count == line_count - 1  && symmetrical_with_smudge_index_count == 1)
      end
    end

    def possible_smudges_and_symmetrical_indices(line, indices)
      possible_smudges = {}
      symmetrical_indices = Set.new

      indices.each do |index|
        is_already_symmetrical = true
        before_index = index - 1
        after_index = index

        while before_index >= 0 && after_index < line.length
          if line[before_index] != line[after_index]
            is_already_symmetrical = false

            if validate_vertical_index([
              *(before_index != 0 ? line.slice(0..(before_index - 1)) : []),
              *line.slice(before_index..(after_index - 1)),
              line[before_index],
              *line.slice((after_index + 1)..(line.length))
            ], index)
              possible_smudges[index] ||= Set.new
              possible_smudges[index] << before_index
              possible_smudges[index] << after_index
            end
          end

          before_index -= 1
          after_index += 1
        end

        symmetrical_indices << index if is_already_symmetrical
      end

      {
        possible_smudges:,
        symmetrical_indices:
      }
    end

    def validate_vertical_index(line, index)
      return false unless index > 0 && index < line.length

      before_index = index - 1
      after_index = index

      while before_index >= 0 && after_index < line.length
        return false unless line[before_index] == line[after_index]

        before_index -= 1
        after_index += 1
      end

      true
    end
  end

  class Input
    include ArrayHelpers

    def initialize(raw_lines:)
      @raw_lines = raw_lines
    end

    def clean
      split_array(raw_lines, '').map { |set| set.map { |str| str.split('') } }
    end

    private

    attr_reader :raw_lines
  end
end
