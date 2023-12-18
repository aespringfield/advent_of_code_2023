describe 'Day10' do
  describe '.part_one' do
    it 'produces the correct output for input A' do
      expect(Day10.part_one(@input_A)).to eq(@part_one_expected_A)
    end

    it 'produces the correct output for input B' do
      expect(Day10.part_one(@input_B)).to eq(@part_one_expected_B)
    end

    it 'produces the correct output for input C' do
      expect(Day10.part_one(@input_C)).to eq(@part_one_expected_C)
    end
  end

  describe '.part_two' do
    it 'produces the correct output for input A' do
      expect(Day10.part_two(@input_A)).to eq(@part_two_expected_A)
    end

    it 'produces the correct output for input B' do
      expect(Day10.part_two(@input_B)).to eq(@part_two_expected_B)
    end
  end

  describe '.adjacent_pipe_coordinates' do
    it 'returns correct output for input A' do
      grid = {
        0 => {
          0 => '.',
          1 => '.',
          2 => '.',
          3 => '.',
          4 => '.'
        },
        1 => {
          0 => '.',
          1 => 'S',
          2 => '-',
          3 => '7',
          4 => '.'
        },
        2 => {
          0 => '.',
          1 => '|',
          2 => '.',
          3 => '|',
          4 => '.'
        },
        3 => {
          0 => '.',
          1 => 'L',
          2 => '-',
          3 => 'J',
          4 => '.'
        },
        4 => {
          0 => '.',
          1 => '.',
          2 => '.',
          3 => '.',
          4 => '.'
        }
      }

      expect(Day10.adjacent_pipe_coordinates([1,1], grid)).to contain_exactly(
        [1, 2],
        [2, 1]
      )
    end

    it 'returns correct output for input B' do
      grid = {
        0 => {0 => '.', 1 => '.', 2 => 'F', 3 => '7', 4 => '.'},
        1 => {0 => '.', 1 => 'F', 2 => 'J', 3 => '|', 4 => '.'},
        2 => {0 => 'S', 1 => 'J', 2 => '.', 3 => 'L', 4 => '7'},
        3 => {0 => '|', 1 => 'F', 2 => '-', 3 => '-', 4 => 'J'},
        4 => {0 => 'L', 1 => 'J', 2 => '.', 3 => '.', 4 => '.'},
      }

      expect(Day10.adjacent_pipe_coordinates([2,0], grid)).to contain_exactly(
        [2, 1],
        [3, 0]
      )

    end
  end

  describe 'Input' do
    describe 'clean' do
      it 'produces the correct cleaned input' do
        expect(Day10::Input.new(raw_lines: @input_A).clean).to eq(
          {
            start_coordinates: [1, 1],
            grid: {
              0 => {
                0 => '.',
                1 => '.',
                2 => '.',
                3 => '.',
                4 => '.'
              },
              1 => {
                0 => '.',
                1 => 'S',
                2 => '-',
                3 => '7',
                4 => '.'
              },
              2 => {
                0 => '.',
                1 => '|',
                2 => '.',
                3 => '|',
                4 => '.'
              },
              3 => {
                0 => '.',
                1 => 'L',
                2 => '-',
                3 => 'J',
                4 => '.'
              },
              4 => {
                0 => '.',
                1 => '.',
                2 => '.',
                3 => '.',
                4 => '.'
              }
            }
          }
        )
      end
    end
  end
end
