describe 'Day06' do
  describe '.part_one' do
    it 'produces the correct output' do
      expect(Day06.part_one(@input)).to eq(@part_one_expected)
    end
  end

  describe '.part_two' do
    it 'produces the correct output' do
      expect(Day06.part_two(@input)).to eq(@part_two_expected)
    end
  end

  describe 'Input' do
    describe 'clean' do
      it 'produces the correct cleaned input when bad_kerning is false' do
        expected_attributes = [
          {
            time: 7,
            distance: 9
          },
          {
            time: 15,
            distance: 40
          },
          {
            time: 30,
            distance: 200
          }
        ]

        Day06::Input.new(raw_lines: @input).clean(bad_kerning: false).each_with_index do |race, i|
          expect(race).to have_attributes(expected_attributes[i])
        end
      end

      it 'produces the correct cleaned input when bad_kerning is true' do
        expect(Day06::Input.new(raw_lines: @input).clean(bad_kerning: true)).to have_attributes(
          {
              time: 71530,
              distance: 940200
          }
        )
      end
    end
  end

  describe 'QuadraticEquation' do
    describe '.solve' do
      it 'solves the quadratic equation' do
        expect(Day06::QuadraticEquation.solve(a: -2, b: 3, c: 4)).to contain_exactly(-0.85078, 2.35078)
      end
    end
  end
end
