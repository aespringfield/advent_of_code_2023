module Day08
  class << self
    def part_one(input)
      instructions, nodes = Input.new(raw_lines: input).clean.values_at(:instructions, :nodes)

      num_steps_to_destination('AAA', 'ZZZ', nodes, instructions)
    end

    def part_two(input)
      instructions, nodes = Input.new(raw_lines: input).clean.values_at(:instructions, :nodes)
      start_nodes = nodes.keys.select { |key| key.match(/A$/) }
      start_nodes.map { |start_node| num_steps_to_destination(start_node, /Z$/, nodes, instructions) }.inject(&:lcm)
    end

    def num_steps_to_destination(start_node, end_node_matcher, nodes, instructions)
      steps_count = 0
      next_node = start_node

      while (!next_node.match(end_node_matcher)) do
        next_node = nodes[next_node][instructions[steps_count % instructions.length]]
        steps_count += 1
      end

      steps_count
    end
  end

  class Input
    def initialize(raw_lines:)
      @raw_lines = raw_lines
    end

    def clean
      instructions = raw_lines[0].split('')
      nodes = raw_lines[2..-1].each_with_object({}) do |line, hash|
        key, left, right = line.match(/(\w+) = \((\w+), (\w+)\)/).captures
        hash[key] = {
          'L' => left,
          'R' => right
        }
      end

      {
        instructions:,
        nodes:
      }
    end

    private

    attr_reader :raw_lines
  end
end
