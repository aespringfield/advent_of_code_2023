describe 'Day05' do
  describe '.part_one' do
    it 'produces the correct output' do
      expect(Day05.part_one(@input)).to eq(@part_one_expected)
    end
  end

  describe '.part_two' do
    it 'produces the correct output' do
      expect(Day05.part_two(@input)).to eq(@part_two_expected)
    end
  end

  describe '.destination_ranges_for_source_ranges' do
    it 'returns source ranges if no matching map' do
      source_ranges = [30..79]
      source_label = 'something else'
      maps = [
        {
          source: 'seed',
          destination: 'soil',
          ranges: [
            {
              destination_range_start: 52,
              source_range_start: 50,
              range_length: 48
            },
            {
              destination_range_start: 50,
              source_range_start: 98,
              range_length: 2
            }
          ]
        }
      ]


      expect(Day05.destination_ranges_for_source_ranges(source_ranges, source_label, maps)).to eq(
        [30..79]
      )
    end

    context 'when only one map in chain' do
      it 'returns correct source range when no range overlap at all' do
        source_ranges = [30..41]
        source_label = 'seed'
        maps = [
          {
            source: 'seed',
            destination: 'soil',
            ranges: [
              {
                destination_range_start: 52,
                source_range_start: 50,
                range_length: 48
              },
              {
                destination_range_start: 50,
                source_range_start: 98,
                range_length: 2
              }
            ]
          }
        ]

        expect(Day05.destination_ranges_for_source_ranges(source_ranges, source_label, maps)).to eq(
          [30..41]
        )
      end

      it 'returns correct range when source range fits within one map range' do
        source_ranges = [58..69]
        source_label = 'seed'
        maps = [
          {
            source: 'seed',
            destination: 'soil',
            ranges: [
              {
                destination_range_start: 52,
                source_range_start: 50,
                range_length: 48
              },
              {
                destination_range_start: 50,
                source_range_start: 98,
                range_length: 2
              }
            ]
          }
        ]

        expect(Day05.destination_ranges_for_source_ranges(source_ranges, source_label, maps)).to eq(
          [60..71]
        )
      end

      it 'returns correct range when multiple overlaps between source ranges and map ranges' do
        source_ranges = [50..60, 80..95]
        source_label = 'seed'
        maps = [
          {
            source: 'seed',
            destination: 'soil',
            ranges: [
              {
                destination_range_start: 52,
                source_range_start: 48,
                range_length: 5
              },
              {
                destination_range_start: 78,
                source_range_start: 70,
                range_length: 2
              },
              {
                destination_range_start: 78,
                source_range_start: 93,
                range_length: 10
              }
            ]
          }
        ]

        expect(Day05.destination_ranges_for_source_ranges(source_ranges, source_label, maps)).to eq(
          [
            54..56,
            53..60,
            80..92,
            78..80
          ]
        )
      end
    end

    context 'when multiple maps in chain' do
      it 'returns correct ranges' do
        source_ranges = [30..41]
        source_label = 'seed'
        maps = [
          {
            source: 'seed',
            destination: 'soil',
            ranges: [
              {
                destination_range_start: 52,
                source_range_start: 50,
                range_length: 48
              },
              {
                destination_range_start: 50,
                source_range_start: 98,
                range_length: 2
              }
            ]
          },
          {
            source: 'soil',
            destination: 'fertilizer',
            ranges: [
              {
                destination_range_start: 94,
                source_range_start: 34,
                range_length: 48
              },
              {
                destination_range_start: 150,
                source_range_start: 200,
                range_length: 2
              }
            ]
          },
        ]

        expect(Day05.destination_ranges_for_source_ranges(source_ranges, source_label, maps)).to eq(
          [
            30..33,
            94..101
          ]
        )
      end
    end
  end

  describe '.paired_source_and_destination_ranges' do
    it 'returns range as both source and destination ranges when map_ranges is empty' do
      expect(Day05.paired_source_and_destination_ranges(20..30, [])).to eq(
        [
          {
            source_range: 20..30,
            destination_range: 20..30
          }
        ]
      )
    end

    it 'returns range as both source and destination ranges when map_ranges does not contain overlaps' do
      map_ranges = [
        {
          source_range: 45..50,
          destination_range: 60..65
        }
      ]

      expect(Day05.paired_source_and_destination_ranges(20..30, map_ranges)).to eq(
        [
          {
            source_range: 20..30,
            destination_range: 20..30
          }
        ]
      )
    end

    it 'returns correct range when range entirely included in one of map_ranges' do
      map_ranges = [
        {
          source_range: 10..50,
          destination_range: 60..100
        }
      ]

      expect(Day05.paired_source_and_destination_ranges(20..30, map_ranges)).to eq(
        [
          {
            source_range: 20..30,
            destination_range: 70..80
          }
        ]
      )
    end

    it 'returns correct ranges when one of map_ranges entirely included in range' do
      map_ranges = [
        {
          source_range: 26..27,
          destination_range: 66..67
        }
      ]

      expect(Day05.paired_source_and_destination_ranges(20..30, map_ranges)).to eq(
        [
          {
            source_range: 20..25,
            destination_range: 20..25
          },
          {
            source_range: 26..27,
            destination_range: 66..67
          },
          {
            source_range: 28..30,
            destination_range: 28..30
          }
        ]
      )
    end

    it 'returns correct ranges when multiple map_ranges match parts of range' do
      map_ranges = [
        {
          source_range: 22..24,
          destination_range: 82..84
        },
        {
          source_range: 26..27,
          destination_range: 66..67
        }
      ]

      expect(Day05.paired_source_and_destination_ranges(20..30, map_ranges)).to eq(
        [
          {
            source_range: 20..21,
            destination_range: 20..21
          },
          {
            source_range: 22..24,
            destination_range: 82..84
          },
          {
            source_range: 25..25,
            destination_range: 25..25
          },
          {
            source_range: 26..27,
            destination_range: 66..67
          },
          {
            source_range: 28..30,
            destination_range: 28..30
          }
        ]
      )
    end
  end

  describe 'Input' do
    describe 'clean' do
      it 'cleans the data when seeds_are_ranges is false' do
        expect(Day05::Input.new(raw_lines: @input).clean(seeds_are_ranges: false)).to eq(
          {
            seeds: [ 79, 14, 55, 13 ],
            maps: [
              {
                source: 'seed',
                destination: 'soil',
                ranges: [
                  {
                    destination_range_start: 52,
                    source_range_start: 50,
                    range_length: 48
                  },
                  {
                    destination_range_start: 50,
                    source_range_start: 98,
                    range_length: 2
                  }
                ]
              },
              {
                source: 'soil',
                destination: 'fertilizer',
                ranges: [
                  {
                    destination_range_start: 39,
                    source_range_start: 0,
                    range_length: 15
                  },
                  {
                    destination_range_start: 0,
                    source_range_start: 15,
                    range_length: 37
                  },
                  {
                    destination_range_start: 37,
                    source_range_start: 52,
                    range_length: 2
                  }
                ]
              },
              {
                source: 'fertilizer',
                destination: 'water',
                ranges: [
                  {
                    destination_range_start: 42,
                    source_range_start: 0,
                    range_length: 7
                  },
                  {
                    destination_range_start: 57,
                    source_range_start: 7,
                    range_length: 4
                  },
                  {
                    destination_range_start: 0,
                    source_range_start: 11,
                    range_length: 42
                  },
                  {
                    destination_range_start: 49,
                    source_range_start: 53,
                    range_length: 8
                  }
                ]
              },
              {
                source: 'water',
                destination: 'light',
                ranges: [
                  {
                    destination_range_start: 88,
                    source_range_start: 18,
                    range_length: 7
                  },
                  {
                    destination_range_start: 18,
                    source_range_start: 25,
                    range_length: 70
                  }
                ]
              },
              {
                source: 'light',
                destination: 'temperature',
                ranges: [
                  {
                    destination_range_start: 81,
                    source_range_start: 45,
                    range_length: 19
                  },
                  {
                    destination_range_start: 68,
                    source_range_start: 64,
                    range_length: 13
                  },
                  {
                    destination_range_start: 45,
                    source_range_start: 77,
                    range_length: 23
                  }
                ]
              },
              {
                source: 'temperature',
                destination: 'humidity',
                ranges: [
                  {
                    destination_range_start: 1,
                    source_range_start: 0,
                    range_length: 69
                  },
                  {
                    destination_range_start: 0,
                    source_range_start: 69,
                    range_length: 1
                  }
                ]
              },
              {
                source: 'humidity',
                destination: 'location',
                ranges: [
                  {
                    destination_range_start: 60,
                    source_range_start: 56,
                    range_length: 37
                  },
                  {
                    destination_range_start: 56,
                    source_range_start: 93,
                    range_length: 4
                  }
                ]
              }
            ]
          }
        )
      end

      it 'cleans the data when seeds_are_ranges is true' do
        expect(Day05::Input.new(raw_lines: @input).clean(seeds_are_ranges: true)).to eq(
          {
            seeds: [79..92, 55..67],
            maps: [
              {
                source: 'seed',
                destination: 'soil',
                ranges: [
                  {
                    destination_range_start: 52,
                    source_range_start: 50,
                    range_length: 48
                  },
                  {
                    destination_range_start: 50,
                    source_range_start: 98,
                    range_length: 2
                  }
                ]
              },
              {
                source: 'soil',
                destination: 'fertilizer',
                ranges: [
                  {
                    destination_range_start: 39,
                    source_range_start: 0,
                    range_length: 15
                  },
                  {
                    destination_range_start: 0,
                    source_range_start: 15,
                    range_length: 37
                  },
                  {
                    destination_range_start: 37,
                    source_range_start: 52,
                    range_length: 2
                  }
                ]
              },
              {
                source: 'fertilizer',
                destination: 'water',
                ranges: [
                  {
                    destination_range_start: 42,
                    source_range_start: 0,
                    range_length: 7
                  },
                  {
                    destination_range_start: 57,
                    source_range_start: 7,
                    range_length: 4
                  },
                  {
                    destination_range_start: 0,
                    source_range_start: 11,
                    range_length: 42
                  },
                  {
                    destination_range_start: 49,
                    source_range_start: 53,
                    range_length: 8
                  }
                ]
              },
              {
                source: 'water',
                destination: 'light',
                ranges: [
                  {
                    destination_range_start: 88,
                    source_range_start: 18,
                    range_length: 7
                  },
                  {
                    destination_range_start: 18,
                    source_range_start: 25,
                    range_length: 70
                  }
                ]
              },
              {
                source: 'light',
                destination: 'temperature',
                ranges: [
                  {
                    destination_range_start: 81,
                    source_range_start: 45,
                    range_length: 19
                  },
                  {
                    destination_range_start: 68,
                    source_range_start: 64,
                    range_length: 13
                  },
                  {
                    destination_range_start: 45,
                    source_range_start: 77,
                    range_length: 23
                  }
                ]
              },
              {
                source: 'temperature',
                destination: 'humidity',
                ranges: [
                  {
                    destination_range_start: 1,
                    source_range_start: 0,
                    range_length: 69
                  },
                  {
                    destination_range_start: 0,
                    source_range_start: 69,
                    range_length: 1
                  }
                ]
              },
              {
                source: 'humidity',
                destination: 'location',
                ranges: [
                  {
                    destination_range_start: 60,
                    source_range_start: 56,
                    range_length: 37
                  },
                  {
                    destination_range_start: 56,
                    source_range_start: 93,
                    range_length: 4
                  }
                ]
              }
            ]
          }
        )
      end
    end
  end
end
