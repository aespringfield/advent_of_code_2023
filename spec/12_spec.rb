describe 'Day12' do
  describe '.part_one' do
    it 'produces the correct output for input A' do
      expect(Day12.part_one(@input_A)).to eq(@part_one_expected_A)
    end

    it 'produces the correct output for input B' do
      expect(Day12.part_one(@input_B)).to eq(@part_one_expected_B)
    end
  end

  describe '.part_two' do
    it 'produces the correct output for input' do
      expect(Day12.part_two(@input)).to eq(@part_two_expected)
    end
  end

  describe '.options_for_springs' do
    it 'produces the correct output when a contiguous length is longer than any spring section' do
      expect(Day12.options_for_springs(%w[? ? ? . # # #], [6])).to eq(0)
    end

    it 'produces the correct output when a contiguous length cannot be mapped to a known section' do
      expect(Day12.options_for_springs(%w[# # # . ? ? ?], [1, 1, 3])).to eq(0)
    end

    it 'produces the correct output when only one option' do
      expect(Day12.options_for_springs(%w[? ? ? . # # #], [1, 1, 3])).to eq(1)
    end

    it 'produces the correct output when only multiple options' do
      expect(Day12.options_for_springs(%w[. ? ? . . ? ? . . . ? # # .], [1, 1, 3])).to eq(4)
    end
  end

  describe 'Input' do
    describe 'clean' do
      it 'produces the correct cleaned input' do
        expect(Day12::Input.new(raw_lines: @input_A).clean).to eq(
          [
            {
              springs: %w[? ? ? . # # #],
              contiguous_damaged_springs: [1,1,3]
            },
            {
              springs: %w[. ? ? . . ? ? . . . ? # # .],
              contiguous_damaged_springs: [1,1,3]
            },
            {
              springs: %w[? # ? # ? # ? # ? # ? # ? # ?],
              contiguous_damaged_springs: [1,3,1,6]
            },
            {
              springs: %w[? ? ? ? . # . . . # . . .],
              contiguous_damaged_springs: [4,1,1]
            },
            {
              springs: %w[? ? ? ? . # # # # # # . . # # # # # .],
              contiguous_damaged_springs: [1,6,5]
            },
            {
              springs: %w[? # # # ? ? ? ? ? ? ? ?],
              contiguous_damaged_springs: [3,2,1]
            }
          ]
        )
      end
    end
  end
end
