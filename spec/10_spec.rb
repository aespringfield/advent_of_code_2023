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
    it 'produces the correct output for input D' do
      expect(Day10.part_two(@input_D)).to eq(@part_two_expected_D)
    end

    it 'produces the correct output for input E' do
      expect(Day10.part_two(@input_E)).to eq(@part_two_expected_E)
    end

    it 'produces the correct output for input F' do
      expect(Day10.part_two(@input_F)).to eq(@part_two_expected_F)
    end
  end

  describe '.pipe_at_coordinates' do
    it 'returns - when all in the same row' do
      expect(Day10.pipe_at_coordinates([0,1],[0,0], [0,2])).to eq('-')
    end

    it 'returns | when all in the same column' do
      expect(Day10.pipe_at_coordinates([1,0],[0,0], [2,0])).to eq('|')
    end

    it 'returns 7 when same row, previous column then next row, same column' do
      expect(Day10.pipe_at_coordinates([0,1], [0,0],[1,1])).to eq('7')
    end

    it 'returns L when previous row, same column then same row, next column' do
      expect(Day10.pipe_at_coordinates([1,0], [0,0],[1,1])).to eq('L')
    end

    it 'returns F when same row, next column then next row, same column' do
      expect(Day10.pipe_at_coordinates([0,0], [0,1],[1,0])).to eq('F')
    end

    it 'returns J when same row, previous column then previous row, same column' do
      expect(Day10.pipe_at_coordinates([1,1], [1,0],[0,1])).to eq('J')
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
