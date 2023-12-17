describe 'Day08' do
  describe '.part_one' do
    it 'produces the correct output for input A' do
      expect(Day08.part_one(@input_A)).to eq(@part_one_expected_A)
    end

    it 'produces the correct output for input B' do
      expect(Day08.part_one(@input_B)).to eq(@part_one_expected_B)
    end

    it 'produces the correct output for input C' do
      expect(Day08.part_one(@input_C)).to eq(@part_one_expected_C)
    end
  end

  describe '.part_two' do
    it 'produces the correct output' do
      expect(Day08.part_two(@input_D)).to eq(@part_two_expected_D)
    end
  end

  describe '.num_steps_to_destination' do
    it 'returns 0 when start node is end node' do
      start_node = 'ZZZ'
      end_node = 'ZZZ'
      instructions = %w[R L]
      nodes = {
        'AAA' => {
          'L' => 'BBB',
          'R' => 'ZZZ'
        }
      }
      expect(Day08.num_steps_to_destination(start_node, end_node, nodes, instructions)).to eq(0)
    end

    it 'returns 1 when start node is 1 step away from end node' do
      start_node = 'AAA'
      end_node = 'ZZZ'
      instructions = %w[R L]
      nodes = {
        'AAA' => {
          'L' => 'BBB',
          'R' => 'ZZZ'
        },
        'ZZZ' => {
          'L' => 'ZZZ',
          'R' => 'ZZZ'
        }
      }
      expect(Day08.num_steps_to_destination(start_node, end_node, nodes, instructions)).to eq(1)
    end
  end

  describe 'Input' do
    describe 'clean' do
      it 'produces the correct cleaned input' do
        expect(Day08::Input.new(raw_lines: @input_A).clean).to eq(
          {
            instructions: %w[R L],
            nodes: {
              'AAA' => {
                'L' => 'BBB',
                'R' => 'CCC'
              },
              'BBB' => {
                'L' => 'DDD',
                'R' => 'EEE'
              },
              'CCC' => {
                'L' => 'ZZZ',
                'R' => 'GGG'
              },
              'DDD' => {
                'L' => 'DDD',
                'R' => 'DDD'
              },
              'EEE' => {
                'L' => 'EEE',
                'R' => 'EEE'
              },
              'GGG' => {
                'L' => 'GGG',
                'R' => 'GGG'
              },
              'ZZZ' => {
                'L' => 'ZZZ',
                'R' => 'ZZZ'
              }
            }
          }
        )
      end
    end
  end
end
