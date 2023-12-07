describe 'Day04' do
  describe '.part_one' do
    it 'produces the correct output' do
      expect(Day04.part_one(@input_A)).to eq(@part_one_expected_A)
    end
  end

  describe '.part_two' do
    it 'produces the correct output' do
      expect(Day04.part_two(@input_A)).to eq(@part_two_expected_A)
    end

    it 'produces the correct output for B' do
      expect(Day04.part_two(@input_B)).to eq(@part_two_expected_B)
    end

    it 'produces the correct output for C' do
      expect(Day04.part_two(@input_C)).to eq(@part_two_expected_C)
    end
  end
end
