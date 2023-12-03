require 'yaml'

RSpec.configure do |config|
  config.before(:suite) do
    $LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

    Dir.glob('[0-9][0-9].rb').each do |file|
      require file
    end
  end

  config.before(:each) do |example|
    path = example.metadata[:example_group][:file_path]
    day = /(\d+)/.match(path)
    if Dir["examples/#{day}/**"].length == 2
      @input = File.readlines("examples/#{day}/A.txt", chomp: true)
      expected = YAML.load_file("examples/#{day}/A_expected.yml")
      @part_one_expected = expected['part_one']
      @part_two_expected = expected['part_two']
    else
      ('A'..'Z').each do |letter|
        break unless File.exist?("examples/#{day}/#{letter}.txt")

        instance_variable_set(
          "@input_#{letter}".to_sym,
          File.readlines("examples/#{day}/#{letter}.txt", chomp: true)
        )
        expected = YAML.load_file("examples/#{day}/#{letter}_expected.yml")
        instance_variable_set(
          "@part_one_expected_#{letter}".to_sym,
          expected['part_one']
        )
        instance_variable_set(
          "@part_two_expected_#{letter}".to_sym,
          expected['part_two']
        )
      end
    end

  end
end
