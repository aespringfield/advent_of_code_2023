describe 'Day09' do
  describe '.part_one' do
    it 'produces the correct output for input A' do
      expect(Day09.part_one(@input_A)).to eq(@part_one_expected_A)
    end
  end

  describe '.part_two' do
    it 'produces the correct output for input A' do
      expect(Day09.part_two(@input_A)).to eq(@part_two_expected_A)
    end

    it 'produces the correct output for input B' do
      expect(Day09.part_two(@input_B)).to eq(@part_two_expected_B)
    end
  end

  describe 'Input' do
    describe 'clean' do
      it 'produces the correct cleaned input' do
        expect(Day09::Input.new(raw_lines: @input_A).clean).to eq(
          [
            [0, 3, 6, 9, 12, 15],
            [1, 3, 6, 10, 15, 21],
            [10, 13, 16, 21, 30, 45]
          ]
        )
      end
    end
  end
end
