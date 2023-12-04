describe 'Day03' do
  SYMBOLS = %w[* + & = $ @ / - % #].freeze

  describe '.part_one' do
    it 'produces the correct output for input A' do
      expect(Day03.part_one(@input_A)).to eq(@part_one_expected_A)
    end

    it 'produces the correct output for input B' do
      expect(Day03.part_one(@input_B)).to eq(@part_one_expected_B)
    end

    it 'produces the correct output for input C' do
      expect(Day03.part_one(@input_C)).to eq(@part_one_expected_C)
    end

    it 'produces the correct output for input D' do
      expect(Day03.part_one(@input_D)).to eq(@part_one_expected_D)
    end

    it 'produces the correct output for input E' do
      expect(Day03.part_one(@input_E)).to eq(@part_one_expected_E)
    end

    context 'when input empty' do
      let(:input) { [] }

      it 'returns 0' do
        expect(Day03.part_one(input)).to eq(0)
      end
    end

    context 'when contains a number and no symbol' do
      let(:input) { [ '234' ] }

      it 'returns 0' do
        expect(Day03.part_one(input)).to eq(0)
      end
    end

    context 'when contains a number and a horizontally adjacent symbol' do
      context 'when number is after symbol' do
        let(:input) { ["234#{symbol}", "222#{symbol}"] }

        SYMBOLS.each do |character|
          context "when symbol is #{character}" do
            let(:symbol) { character }

            it 'returns number' do
              expect(Day03.part_one(input)).to eq(456)
            end
          end
        end
      end

      context 'when number is before symbol' do
        let(:input) { ["#{symbol}234", "#{symbol}222"] }

        SYMBOLS.each do |character|
          context "when symbol is #{character}" do
            let(:symbol) { character }

            it 'returns number' do
              expect(Day03.part_one(input)).to eq(456)
            end
          end
        end
      end
    end

    context 'when contains a number and a vertically adjacent symbol' do
      context 'when number is above symbol' do
        let(:input) { ["234..", ".#{symbol}..."] }

        SYMBOLS.each do |character|
          context "when symbol is #{character}" do
            let(:symbol) { character }

            it 'returns number' do
              expect(Day03.part_one(input)).to eq(234)
            end
          end
        end
      end

      context 'when number is below symbol' do
        let(:input) { [".#{symbol}...", "234..", ] }

        SYMBOLS.each do |character|
          context "when symbol is #{character}" do
            let(:symbol) { character }

            it 'returns number' do
              expect(Day03.part_one(input)).to eq(234)
            end
          end
        end
      end
    end

    context 'when contains a number and a diagonally adjacent symbol' do
      context 'when number is above symbol to left' do
        let(:input) { ["234..", "...#{symbol}."] }

        SYMBOLS.each do |character|
          context "when symbol is #{character}" do
            let(:symbol) { character }

            it 'returns number' do
              expect(Day03.part_one(input)).to eq(234)
            end
          end
        end
      end

      context 'when number is above symbol to right' do
        let(:input) { [".234..", "#{symbol}...."] }

        SYMBOLS.each do |character|
          context "when symbol is #{character}" do
            let(:symbol) { character }

            it 'returns number' do
              expect(Day03.part_one(input)).to eq(234)
            end
          end
        end
      end

      context 'when number is below symbol to left' do
        let(:input) { ["...#{symbol}.", "234.."] }

        SYMBOLS.each do |character|
          context "when symbol is #{character}" do
            let(:symbol) { character }

            it 'returns number' do
              expect(Day03.part_one(input)).to eq(234)
            end
          end
        end
      end

      context 'when number is below symbol to right' do
        let(:input) { ["#{symbol}....", ".234."] }

        SYMBOLS.each do |character|
          context "when symbol is #{character}" do
            let(:symbol) { character }

            it 'returns number' do
              expect(Day03.part_one(input)).to eq(234)
            end
          end
        end
      end
    end

    context 'when contains a number and a non-adjacent symbol' do
      let(:input) { ["234.#{symbol}"] }

      SYMBOLS.each do |character|
        context "when symbol is #{character}" do
          let(:symbol) { character }

          it 'returns number' do
            expect(Day03.part_one(input)).to eq(0)
          end
        end
      end
    end
  end

  describe '.part_two' do
    it 'produces the correct output for input A' do
      expect(Day03.part_two(@input_A)).to eq(@part_two_expected_A)
    end

    it 'produces the correct output for input F' do
      expect(Day03.part_two(@input_F)).to eq(@part_two_expected_F)
    end

    context 'when input empty' do
      let(:input) { [] }

      it 'returns 0' do
        expect(Day03.part_two(input)).to eq(0)
      end
    end

    context 'when contains no gears' do
      let(:input) { [ '234.783' ] }

      it 'returns 0' do
        expect(Day03.part_two(input)).to eq(0)
      end
    end

    context 'when contains a gear' do
      context 'when horizontal' do
        let(:input) { [ '234*783' ] }

        it 'returns correct value' do
          expect(Day03.part_two(input)).to eq(183_222)
        end
      end

      context 'when vertical' do
        let(:input) { [ '.234..', '..*...', '..22.' ] }

        it 'returns correct value' do
          expect(Day03.part_two(input)).to eq(5148)
        end
      end

      context 'when diagonal to left' do
        let(:input) { [ '23...', '..*...', '22...' ] }

        it 'returns correct value' do
          expect(Day03.part_two(input)).to eq(506)
        end
      end

      context 'when diagonal to right' do
        let(:input) { [ '...23', '..*...', '...22' ] }

        it 'returns correct value' do
          expect(Day03.part_two(input)).to eq(506)
        end
      end
    end
  end
end
