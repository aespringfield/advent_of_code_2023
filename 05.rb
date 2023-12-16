require_relative 'lib/array_helpers.rb'

module Day05
  # LABELS = %w[seed soil fertilizer water light temperature humidity location]

  class << self
    def part_one(input)
      seeds, maps = Input.new(raw_lines: input).clean.values_at(:seeds, :maps)
      seeds.map { |seed| destination_for_source(seed, 'seed', maps) }.min
    end

    def part_two(input)
      seed_ranges, maps = Input.new(raw_lines: input).clean(seeds_are_ranges: true).values_at(:seeds, :maps)

      destination_ranges_for_source_ranges(seed_ranges, 'seed', maps).map(&:begin).min
    end

    def destination_for_source(source_value, source_label, maps)
      #   Find correct map--if no map, return value
      map = maps.find { |map| map[:source] == source_label }
      return source_value unless map
      #   Fetch sorted source starts
      #   Find first one that isn't higher than input
      range_index = map[:ranges].bsearch_index { |range| range[:source_range_start] > source_value }
      range = map[:ranges][range_index ? range_index - 1 : -1]
      #   Find difference from input, add to destination range start
      #   (or return source value if not found)
      destination_value = if source_value >= range[:source_range_start] && range[:source_range_start] + range[:range_length] >= source_value
                            range[:destination_range_start] + source_value - range[:source_range_start]
                          else
                            source_value
                          end
      #   Return output plugged in as input
      destination_for_source(destination_value, map[:destination], maps)
    end

    def destination_ranges_for_source_ranges(source_ranges, source_label, maps)
      map = maps.find { |map| map[:source] == source_label }

      return source_ranges unless map

      map_ranges = map[:ranges].map do |range|
        {
          source_range: range[:source_range_start]..(range[:source_range_start] + range[:range_length] - 1),
          destination_range: range[:destination_range_start]..(range[:destination_range_start] + range[:range_length] -1)
        }
      end

      destination_ranges = source_ranges.map do |source_range|
        paired_source_and_destination_ranges(source_range, map_ranges)
      end.flatten.map { |hash| hash[:destination_range] }

      destination_ranges_for_source_ranges(destination_ranges, map[:destination], maps)
    end


    # input: range, ranges to check against
    #  e.g.
    #   range: 20..30
    #   ranges = [
    #         {
    #           source_range: 10..15,
    #           destination_range: 40..45
    #         },
    #         {
    #           source_range: 20..25,
    #           destination_range: 70..75
    #         },
    #         {
    #           source_range: 27..32,
    #           destination_range: 87..92
    #         },
    #         {
    #           source_range: 50..100,
    #           destination_range: 100..150
    #         }
    #       ]
    # output: array of hashes with source and destination ranges
    #   e.g.
    #   [
    #       {
    #         source_range: 20..25,
    #         destination_range: 70..75
    #       },
    #       {
    #         source_range: 26..26,
    #         destination_range: 26..26
    #       },
    #       {
    #         source_range: 27..30,
    #         destination_range: 87..90
    #       }
    #     ]
    def paired_source_and_destination_ranges(range, map_ranges)
      first_matching_map_range = map_ranges.find do |map_range|
        map_range[:source_range].include?(range.begin) || range.include?(map_range[:source_range].begin)
      end

      return [
        {
          source_range: range,
          destination_range: range
        }
      ] if first_matching_map_range.nil?

      source_range_overlap_start = [range.begin, first_matching_map_range[:source_range].begin].max
      source_range_overlap_end = [range.end, first_matching_map_range[:source_range].end].min
      offset = first_matching_map_range[:destination_range].begin - first_matching_map_range[:source_range].begin
      overlap_range = source_range_overlap_start..source_range_overlap_end
      range_hashes_before = overlap_range.begin > range.begin ?
          [
            (range.begin)..(overlap_range.begin - 1)
          ].map do |range|
            {
              source_range: range,
              destination_range: range
            }
          end
          : []
      range_hashes_after = overlap_range.end < range.end ?
          paired_source_and_destination_ranges((overlap_range.end + 1)..(range.end), map_ranges)
          : []

      [
        *range_hashes_before,
        {
          source_range: overlap_range,
          destination_range: (source_range_overlap_start + offset)..(source_range_overlap_end + offset)
        },
        *range_hashes_after
      ]
    end
  end

  class Input
    include ArrayHelpers

    def initialize(raw_lines:)
      @raw_lines = raw_lines
    end

    def clean(seeds_are_ranges: false)
      seeds = seeds_are_ranges ? seeds_as_ranges : seeds_as_separate_values

      {
        seeds:,
        maps:
      }
    end

    private

    def maps
      split_array(@raw_lines[1..-1], '').map do |map_lines|
        source, destination = map_lines[0].match(/^(\w+)-to-(\w+) map\:$/).captures
        ranges = map_lines[1..-1].map do |range_line|
          destination_range_start, source_range_start, range_length = range_line.match(/^(\d+) (\d+) (\d+)$/).captures.map(&:to_i)
          {
            destination_range_start:,
            source_range_start:,
            range_length:
          }
        end.sort_by { |range| range[:source_range_start] }

        {
          source:,
          destination:,
          ranges:
        }
      end
    end

    def seeds_as_separate_values
      @raw_lines[0].match(/^seeds\: (.*)/).captures.first.split(' ').map(&:to_i)
    end

    def seeds_as_ranges
      seeds_as_separate_values.each_slice(2).map { |range_start, range_length|  range_start..(range_start + range_length - 1) }
    end
  end
end
