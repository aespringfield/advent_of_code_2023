describe 'Day11' do
  describe '.part_one' do
    it 'produces the correct output for input' do
      expect(Day11.part_one(@input)).to eq(@part_one_expected)
    end
  end

  describe '.part_two' do
    it 'produces the correct output for input' do
      expect(Day11.part_two(@input)).to eq(@part_two_expected)
    end
  end

  describe '.galaxy_distances_sum' do
    it 'returns correct output for input when expansion factor is 10' do
      expect(Day11.galaxy_distances_sum(@input, 10)).to eq(1030)
    end

    it 'returns correct output for input when expansion factor is 10' do
      expect(Day11.galaxy_distances_sum(@input, 100)).to eq(8410)
    end
  end

  describe 'Input' do
    describe 'clean' do
      it 'produces the correct cleaned input' do
        expect(Day11::Input.new(raw_lines: @input, expansion_factor: 2).clean).to eq(
          {
            1 => [0, 4],
            2 => [1, 9],
            3 => [2, 0],
            4 => [5, 8],
            5 => [6, 1],
            6 => [7, 12],
            7 => [10, 9],
            8 => [11, 0],
            9 => [11, 5]
          }
        )
      end
    end
  end
end
