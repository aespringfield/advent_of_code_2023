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

  describe '.game_index' do
    it 'returns the game index' do
      expect(Day02.send(:game_index, 'Game 17: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red')).to eq(17)
    end
  end

  describe '.cube_data' do
    it 'returns the cube reveal data for one color' do
      expect(Day02.send(:cube_data, '3 green')).to eq(
        {
          green: 3
        }
      )
    end

    it 'returns the cube reveal data for multiple colors' do
      expect(Day02.send(:cube_data, '1 green, 3 red, 6 blue')).to eq(
        {
          green: 1,
          red: 3,
          blue: 6
        }
      )
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

  describe '.is_impossible?' do
    before do
      allow(Day02).to receive(:CUBE_SET).and_return(
        {
          blue: 10,
          green: 12
        }
      )
    end

    it 'returns false when input empty' do
      expect(Day02.send(:is_impossible?, {})).to be(false)
    end

    it 'returns true when subset contains color with greater count than cube set' do
      expect(Day02.send(:is_impossible?, {
        green: 14
      })).to be(true)
    end

    it 'returns false when input is subset of cube set' do
      expect(Day02.send(:is_impossible?, {
        green: 3
      })).to be(false)
    end

    it 'returns true when input contains color not present in cube set' do
      expect(Day02.send(:is_impossible?, {
        green: 3,
        orange: 1
      })).to be(true)
    end
  end

  describe '.counts_by_color' do
    it 'returns correct counts' do
      expect(Day02.send(:counts_by_color, [
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
      )).to eq(
        {
          green: [1, 3, 3],
          red: [3, 6, 14],
          blue: [6, 15]
        }
      )
    end
  end
end
