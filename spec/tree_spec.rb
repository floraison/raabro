
#
# specifying raabro
#
# Tue Sep 22 07:55:52 JST 2015
#

require 'spec_helper'


describe Raabro::Tree do

  describe '.lookup' do

    it 'returns the first node with the given name' do

      t = Sample::Cal.parse('4 5 6 + 1 2 3 * +')

      expect(
        t.lookup('item').to_a(:leaves)
      ).to eq(
        [ :item, 1, 0, 1, nil, :alt, [
          [ :num, 1, 0, 1, nil, :rex, '4' ]
        ] ]
      )
    end
  end

  describe '.gather' do

    it 'returns all the nodes with a given name' do

      t = Sample::Cal.parse('4 5 6 + 1 2 3 * +')

      expect(
        t.gather('op').collect { |n| n.to_a(:leaves) }
      ).to eq(
        [
          [ :op, 1, 6, 1, nil, :rex, '+' ],
          [ :op, 1, 14, 1, nil, :rex, '*' ],
          [ :op, 1, 16, 1, nil, :rex, '+' ]
        ]
      )
    end
  end
end

