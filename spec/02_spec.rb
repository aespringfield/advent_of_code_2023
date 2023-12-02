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

  describe 'Line' do
    let(:raw_line) { 'Game 17: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red' }
    subject { Day02::Line.new(raw_line:) }

    describe '.clean' do
      it 'returns the cleaned data' do
        game = subject.send(:clean, )
        expect(game.index).to eq(17)
        expect(game.cube_draws).to eq(
          [
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
        )
      end
    end
  end
end
