module ArrayHelpers
  def split_array(array, delimiter, &block)
    array.each_with_object([]) do |el, acc|
      acc << [] && next if el == delimiter
      acc << [block_given? ? block.call(el) : el] && next if acc.empty?

      acc.last << (block_given? ? block.call(el) : el)
    end
  end
end