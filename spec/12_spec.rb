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
    it 'produces the correct output for input A' do
      expect(Day12.part_two(@input_A)).to eq(@part_two_expected_A)
    end

    it 'produces the correct output for input B' do
      expect(Day12.part_two(@input_B)).to eq(@part_two_expected_B)
    end
  end

  describe '.springs_options_count' do
    it 'returns 1 when both empty' do
      expect(Day12.springs_options_count('', [])).to eq(1)
    end

    it 'returns 0 when there are runs but no springs' do
      expect(Day12.springs_options_count('', [1])).to eq(0)
    end

    it 'returns 1 when there are no runs and springs are all .' do
      expect(Day12.springs_options_count('....', [])).to eq(1)
    end

    it 'returns 0 when there is no . or ? to end the section' do
      expect(Day12.springs_options_count('.#?#', [2,1])).to eq(0)
    end

    it 'returns 0 when runs longer than possible springs' do
      expect(Day12.springs_options_count('.#?#', [4])).to eq(0)
    end

    it 'returns 0 when runs longer than possible springs with . after' do
      expect(Day12.springs_options_count('.#?#.', [4])).to eq(0)
    end

    it 'returns 0 when no room for . in between' do
      expect(Day12.springs_options_count('.#?#?', [2,2])).to eq(0)
    end

    it 'returns 1 when room for . in between' do
      expect(Day12.springs_options_count('.##?#?', [2,2])).to eq(1)
    end

    it 'returns 1 when all ? can be replaced by .' do
      expect(Day12.springs_options_count('.??#.?', [1])).to eq(1)
    end

    it 'produces correct output when one option' do
      expect(Day12.springs_options_count('???#?', [2, 1])).to eq(1)
    end

    it 'produces the correct output when multiple options' do
      expect(Day12.springs_options_count('?????##', [1, 1, 3])).to eq(1)
    end

    it 'produces correct output for line 1' do
      expect(Day12.springs_options_count('???.###', [1, 1, 3])).to eq(1)
    end

    it 'produces correct output for line 2' do
      expect(Day12.springs_options_count('.??..??...?##.', [1, 1, 3])).to eq(4)
    end
  end

  describe 'Input' do
    describe 'clean' do
      it 'produces the correct cleaned input' do
        expect(Day12::Input.new(raw_lines: @input_A).clean).to eq(
          [
            {
              springs: '???.###',
              contiguous_damaged_springs: [1,1,3]
            },
            {
              springs: '.??..??...?##.',
              contiguous_damaged_springs: [1,1,3]
            },
            {
              springs: '?#?#?#?#?#?#?#?',
              contiguous_damaged_springs: [1,3,1,6]
            },
            {
              springs: '????.#...#...',
              contiguous_damaged_springs: [4,1,1]
            },
            {
              springs: '????.######..#####.',
              contiguous_damaged_springs: [1,6,5]
            },
            {
              springs: '?###????????',
              contiguous_damaged_springs: [3,2,1]
            }
          ]
        )
      end
    end
  end
end
