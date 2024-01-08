describe 'Day14' do
  describe '.part_one' do
    it 'produces the correct output for input A' do
      expect(Day14.part_one(@input_A)).to eq(@part_one_expected_A)
    end
  end

  describe '.part_two' do
    it 'produces the correct output for input A' do
      expect(Day14.part_two(@input_A)).to eq(@part_two_expected_A)
    end

    it 'produces the correct output for input B' do
      expect(Day14.part_two(@input_B)).to eq(@part_two_expected_B)
    end
  end

  describe '.calculate_total_load' do
    it 'returns 0 when lines empty' do
      expect(Day14.calculate_total_load([])).to eq(0)
    end

    it 'returns correct load for single line' do
      expect(Day14.calculate_total_load([%w[O O . # O .]])).to eq(3)
    end

    it 'returns correct load for multiple lines' do
      expect(Day14.calculate_total_load([%w[O O . # O .], %w[. . O # O .]])).to eq(8)
    end

    it 'returns correct load for a bunch of lines' do
      lines = [
        %w[. . . . . # . . . .],
        %w[. . . . # . . . O #],
        %w[. . . . . # # . . .],
        %w[. . . # . . . . . .],
        %w[. . . . . O O O # .],
        %w[. O # . . . O # . #],
        %w[. . . . O # . . . O],
        %w[. . . . . . O O O O],
        %w[# . . . O # # # . O],
        %w[# . . O O # . . O O]
      ]

      expect(Day14.calculate_total_load(lines)).to eq(65)
    end
  end

  describe '.tilt' do
    let(:lines) do
      [
        %w[ . . O . # . O # O],
        %w[ O . O # # . # . .],
        %w[ . O . # . O . O #]
      ]
    end

    it 'tilts east' do
      expect(Day14.tilt(lines, Day14::DIRECTIONS[:east])).to eq([
        %w[ . . . O # . O # O],
        %w[ . O O # # . # . .],
        %w[ . . O # . . O O #],
      ])
    end

    it 'tilts west' do
      expect(Day14.tilt(lines, Day14::DIRECTIONS[:west])).to eq([
        %w[ O . . . # O . # O],
        %w[ O O . # # . # . .],
        %w[ O . . # O O . . #],
      ])
    end

    it 'tilts south' do
      expect(Day14.tilt(lines, Day14::DIRECTIONS[:south])).to eq([
        %w[ . . . . # . O # .],
        %w[ . . O # # . # . O],
        %w[ O O O # . O . O #]
      ])
    end

    it 'tilts north' do
      expect(Day14.tilt(lines, Day14::DIRECTIONS[:north])).to eq([
        %w[ O O O . # O O # O],
        %w[ . . O # # . # O .],
        %w[ . . . # . . . . #]
      ])
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
