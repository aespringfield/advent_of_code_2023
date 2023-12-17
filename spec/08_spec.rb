describe 'Day07' do
  describe '.part_one' do
    it 'produces the correct output' do
      expect(Day07.part_one(@input)).to eq(@part_one_expected)
    end
  end

  describe '.part_two' do
    it 'produces the correct output' do
      expect(Day07.part_two(@input)).to eq(@part_two_expected)
    end
  end

  describe 'Input' do
    describe 'clean' do
      it 'produces the correct cleaned input when bad_kerning is true' do
        expect(Day07::Input.new(raw_lines: @input).clean).to eq(
          [
            {
              hand: %w[3 2 T 3 K],
              bid: 765
            },
            {
              hand: %w[T 5 5 J 5],
              bid: 684
            },
            {
              hand: %w[K K 6 7 7],
              bid: 28
            },
            {
              hand: %w[K T J J T],
              bid: 220
            },
            {
              hand: %w[Q Q Q J A],
              bid: 483
            }
          ]
        )
      end
    end
  end
end
