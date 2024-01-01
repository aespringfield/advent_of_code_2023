describe 'Day13' do
  describe '.part_one' do
    it 'produces the correct output for input' do
      expect(Day13.part_one(@input)).to eq(@part_one_expected)
    end
  end

  describe '.part_two' do
    it 'produces the correct output for input' do
      expect(Day13.part_two(@input)).to eq(@part_two_expected)
    end
  end

  describe '.select_valid_horizontal_indices' do
    it 'returns an empty array when possible indices is []' do
      expect(Day13.select_valid_horizontal_indices(Day13::Input.new(raw_lines: @input).clean, [])).to eq([])
    end

    it 'returns possible indices when lines is []' do
      expect(Day13.select_valid_horizontal_indices([], [3, 4, 8])).to eq([3, 4, 8])
    end

    it 'returns an empty array when no indices are possible' do
      lines = [
        %w[# . # . # .],
        %w[. # . # . #]
      ]

      expect(Day13.select_valid_horizontal_indices(lines, [3, 4, 8])).to eq([])
    end

    it 'returns array containing one possible index when one index is possible' do
      lines = [
        %w[. .],
        %w[# #],
        %w[# #],
        %w[. .]
      ]

      expect(Day13.select_valid_horizontal_indices(lines, [1, 2, 3])).to eq([2])
    end

    it 'returns array containing multiple possible indices when multiple indices are possible' do
      lines = [
        %w[# #],
        %w[# #],
        %w[# #],
        %w[# #]
      ]

      expect(Day13.select_valid_horizontal_indices(lines, [1, 2, 3, 4])).to eq([1, 2, 3])
    end
  end

  describe '.select_valid_vertical_indices' do
    it 'returns an empty array when possible indices is []' do
      expect(Day13.select_valid_vertical_indices(Day13::Input.new(raw_lines: @input).clean, [])).to eq([])
    end

    it 'returns possible indices when lines is []' do
      expect(Day13.select_valid_vertical_indices([], [3, 4, 8])).to eq([3, 4, 8])
    end

    it 'returns an empty array when no indices are possible' do
      expect(Day13.select_valid_vertical_indices([%w[# . # . # .]], [3, 4, 8])).to eq([])
    end

    it 'returns array containing one possible index when one index is possible' do
      expect(Day13.select_valid_vertical_indices([%w[. # # .]], [1, 2, 3])).to eq([2])
    end

    it 'returns array containing multiple indices when multiple indices are possible' do
      expect(Day13.select_valid_vertical_indices([%w[# # # #]], [1, 2, 3, 4])).to eq([1, 2, 3])
    end
  end

  describe '.validate_vertical_index' do
    it 'returns false if index is 0' do
      expect(Day13.validate_vertical_index(%w[. # # .], 0)).to be(false)
    end

    it 'returns false if index is not in array' do
      expect(Day13.validate_vertical_index(%w[. # # .], 4)).to be(false)
    end

    it 'returns true if array is all the same' do
      expect(Day13.validate_vertical_index(%w[# # # #], 2)).to be(true)
    end

    it 'returns false if array not symmetrical' do
      expect(Day13.validate_vertical_index(%w[# . # .], 2)).to be(false)
    end

    it 'returns false if array symmetrical across a different index' do
      expect(Day13.validate_vertical_index(%w[# . # #], 2)).to be(false)
    end

    it 'returns true if array symmetrical across provided index' do
      expect(Day13.validate_vertical_index(%w[. # # # # . #], 3)).to be(true)
    end
  end

  describe '.select_valid_vertical_indices_with_smudge' do
    it 'returns an empty array when possible indices is []' do
      lines = Day13::Input.new(raw_lines: @input).clean.first

      expect(Day13.select_valid_vertical_indices_with_smudge(lines)).to eq(Set.new([]))
    end

    it 'returns possible indices when lines is []' do
      expect(Day13.select_valid_vertical_indices_with_smudge([], {
        0 => {
          symmetrical_with_smudge_indices: Set.new([3]),
          symmetrical_indices: Set.new
        }
      }, 1)).to eq(Set.new([3]))
    end

    it 'returns an empty array when no indices are possible' do
      expect(Day13.select_valid_vertical_indices_with_smudge([%w[#]], {
        0 => {
          symmetrical_with_smudge_indices: Set.new([3]),
          symmetrical_indices: Set.new([3])
        }
      })).to eq(Set.new)
    end

    it 'returns an empty array for multiple lines with no valid smudge' do
      lines = [
        %w[# . # # . . # # .],
        %w[. . # . # # . # .],
        %w[# # . . . . . . #],
        %w[# # . . . . . . #],
        %w[. . # . # # . # .],
        %w[. . # # . . # # .],
        %w[# . # . # # . # .]
      ]

      expect(Day13.select_valid_vertical_indices_with_smudge(lines)).to eq(Set.new)
    end

    it 'returns an array with the correct indices for multiple lines with a valid smudge' do
      lines = [
        %w[# . # # . . # # .],
        %w[. . # . # # . # .],
        %w[# # . . . . # . #],
        %w[# # . . . . . . #],
        %w[. . # . # # . # .],
        %w[. . # # . . # # .],
        %w[# . # . # # . # .]
      ]

      expect(Day13.select_valid_vertical_indices_with_smudge(lines)).to eq(Set.new([5]))
    end
  end

  describe '.select_valid_horizontal_indices_with_smudge' do
    it 'returns an empty array when no indices are possible' do
      lines = [
        %w[# . # . # .],
        %w[. # . # . #]
      ]

      expect(Day13.select_valid_horizontal_indices_with_smudge(lines)).to eq(Set.new)
    end

    it 'returns array containing multiple possible indices when multiple indices are possible' do
      lines = [
        %w[. .],
        %w[# .],
        %w[# #],
        %w[. .]
      ]

      expect(Day13.select_valid_horizontal_indices_with_smudge(lines)).to eq(Set.new([1, 2]))
    end

    it 'returns array containing correct index for example set 1' do
      lines = [
        %w[# . # # . . # # .],
        %w[. . # . # # . # .],
        %w[# # . . . . . . #],
        %w[# # . . . . . . #],
        %w[. . # . # # . # .],
        %w[. . # # . . # # .],
        %w[# . # . # # . # .]
      ]

      expect(Day13.select_valid_horizontal_indices_with_smudge(lines)).to eq(Set.new([3]))
    end
  end

  describe '.possible_indices' do
    it 'returns empty set when line indices is empty' do
      expect(Day13.possible_indices({})).to eq(Set.new)
    end

    it 'returns an empty array when both are empty' do
      expect(Day13.possible_indices(
        0 => {
          symmetrical_with_smudge_indices: Set.new,
          symmetrical_indices: Set.new
        }
      )).to eq(Set.new)
    end

    it 'returns all indices that are in all symmetrical indices' do
      expect(Day13.possible_indices({
        0 => {
          symmetrical_with_smudge_indices: Set.new,
          symmetrical_indices: Set.new([1, 3, 4])
        },
        1 => {
          symmetrical_with_smudge_indices: Set.new,
          symmetrical_indices: Set.new([1, 4])
        }
      }

      )).to eq(Set.new([1, 4]))
    end

    it 'returns index in smudge indices when only one line' do
      expect(Day13.possible_indices({
        0 => {
          symmetrical_with_smudge_indices: Set.new([3]),
          symmetrical_indices: Set.new
        }
      }

      )).to eq(Set.new([3]))
    end

    it 'returns all indices that are in all symmetrical indices or one smudge index' do
      expect(Day13.possible_indices({
        0 => {
          symmetrical_with_smudge_indices: Set.new,
          symmetrical_indices: Set.new([1, 3, 4, 5])
        },
        1 => {
          symmetrical_with_smudge_indices: Set.new([1, 3, 5]),
          symmetrical_indices: Set.new([4])
        },
        2 => {
          symmetrical_with_smudge_indices: Set.new([5]),
          symmetrical_indices: Set.new([1, 4, 5])
        },
        3 => {
          symmetrical_with_smudge_indices: Set.new([5]),
          symmetrical_indices: Set.new([1, 4, 5])
        }
      }

      )).to eq(Set.new([1, 4]))
    end

    it 'returns all indices that are in all but one symmetrical indices and only one smudge index if boolean true' do
      expect(Day13.possible_indices({
        0 => {
          symmetrical_with_smudge_indices: Set.new,
          symmetrical_indices: Set.new([1, 3, 4, 5])
        },
        1 => {
          symmetrical_with_smudge_indices: Set.new([1, 3, 5]),
          symmetrical_indices: Set.new([4])
        },
        2 => {
          symmetrical_with_smudge_indices: Set.new([5]),
          symmetrical_indices: Set.new([1, 4, 5])
        },
        3 => {
          symmetrical_with_smudge_indices: Set.new([5]),
          symmetrical_indices: Set.new([1, 4, 5])
        }
      }, 4, false

      )).to eq(Set.new([1]))
    end
  end

  describe '.possible_smudges_and_symmetrical_indices' do
    it 'returns all empty stuff when no smudge can make indices work and it does not already have symmetry' do
      expect(Day13.possible_smudges_and_symmetrical_indices(%w[# . # . .], [2])).to eq(
        {
          possible_smudges: {},
          symmetrical_indices: Set.new
        }
      )
    end

    it 'returns correct results when index is 1' do
      expect(Day13.possible_smudges_and_symmetrical_indices(%w[# . # # .], [1])).to eq(
        {
          possible_smudges: {
            1 => Set.new([0, 1])
          },
          symmetrical_indices: Set.new
        }
      )
    end

    it 'returns correct results when smudges can make indices work and it does not already have symmetry' do
      expect(Day13.possible_smudges_and_symmetrical_indices(%w[# . # # .], [2])).to eq(
        {
          possible_smudges: {
            2 => Set.new([1, 2])
          },
          symmetrical_indices: Set.new
        }
      )
    end

    it 'returns correct results when indices already have symmetry' do
      expect(Day13.possible_smudges_and_symmetrical_indices(%w[# # # # # #], [2, 3])).to eq(
        {
          possible_smudges: {},
          symmetrical_indices: Set.new([2, 3])
        }
      )
    end

    it 'returns correct results for problem line' do
      expect(Day13.possible_smudges_and_symmetrical_indices(%w[# . # # . . # # .], [1, 2, 3, 4, 5, 6, 7, 8])).to eq(
        {
          possible_smudges: {
            1 => Set.new([0, 1]),
            2 => Set.new([1, 2]),
            3 => Set.new([0, 5]),
            8 => Set.new([7, 8])
          },
          symmetrical_indices: Set.new([5, 7])
        }
      )
    end

    it 'returns correct results for problem line 2' do
      expect(Day13.possible_smudges_and_symmetrical_indices(%w[. . # . # # . # .], [1, 2, 3, 4, 5, 6, 7, 8])).to eq(
        {
          possible_smudges: {
            2 => Set.new([1, 2]),
            6 => Set.new([5, 6]),
            8 => Set.new([7, 8])
          },
          symmetrical_indices: Set.new([1, 5])
        }
      )
    end
  end

  describe 'Input' do
    describe 'clean' do
      it 'produces the correct cleaned input' do
        expect(Day13::Input.new(raw_lines: @input).clean).to eq(
          [
            [
              %w[# . # # . . # # .],
              %w[. . # . # # . # .],
              %w[# # . . . . . . #],
              %w[# # . . . . . . #],
              %w[. . # . # # . # .],
              %w[. . # # . . # # .],
              %w[# . # . # # . # .]
            ],
            [
              %w[# . . . # # . . #],
              %w[# . . . . # . . #],
              %w[. . # # . . # # #],
              %w[# # # # # . # # .],
              %w[# # # # # . # # .],
              %w[. . # # . . # # #],
              %w[# . . . . # . . #]
            ]
          ]
        )
      end
    end
  end
end
