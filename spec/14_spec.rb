describe 'Day13' do
  describe '.part_one' do
    it 'produces the correct output for input' do
      expect(Day14.part_one(@input)).to eq(@part_one_expected)
    end
  end

  describe '.part_two' do
    it 'produces the correct output for input' do
      expect(Day14.part_two(@input)).to eq(@part_two_expected)
    end
  end

  describe 'Input' do
    describe 'clean' do
      it 'produces the correct cleaned input' do
        lines = %w[.#.000 .#.0.#]

        expect(Day14::Input.new(raw_lines: lines).clean).to eq(
          [
            %w[. # . 0 0 0],
            %w[. # . 0 . #]
          ]
        )
      end
    end
  end
end
