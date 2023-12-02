describe 'Day02' do
  describe '.part_one' do
    it 'produces the correct output' do
      expect(Day02.part_one(@input)).to eq(@part_one_expected)
    end
  end

  describe '.part_two' do
    it 'produces the correct output' do
      expect(Day02.part_two(@input)).to eq(@part_two_expected)
    end
  end

  describe '.clean' do
    it 'returns the cleaned data' do
      expect(Day02.send(:clean, 'Game 17: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red')).to eq(
        {
          game: 17,
          cubes: [
            {
              green: 1,
              red: 3,
              blue: 6
            },
            {
              green: 3,
              red: 6
            },
            {
              green: 3,
              blue: 15,
              red: 14
            }
          ]
        }
      )
    end
  end
end
