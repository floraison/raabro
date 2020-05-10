
#
# specifying raabro
#
# Tue Sep 22 07:55:52 JST 2015
#

require 'spec_helper'


describe Raabro::Tree do

  describe '.lookup' do

    it 'returns the first node with the given name' do

      t = Sample::Cal.parse('4 5 6 + 1 2 3 * +', rewrite: false)

      expect(
        t.lookup('item').to_a(:leaves)
      ).to eq(
        [ :item, 1, 0, 1, nil, :alt, [
          [ :num, 1, 0, 1, nil, :rex, '4' ] ] ]
      )
    end

    it 'returns the first named node if the given name is nil' do

      t = Sample::Cal.parse('4 5 6 + 1 2 3 * +', rewrite: false)

      expect(
        t.lookup.to_a(:leaves)
      ).to eq(
        [ :item, 1, 0, 1, nil, :alt, [
          [ :num, 1, 0, 1, nil, :rex, '4' ] ] ]
      )
    end
  end

  describe '.sublookup' do

    it 'skips the callee node' do

      t = Sample::Cal.parse('4 5 6 + 1 2 3 * +', rewrite: false)
      t = t.children[0]

      expect(
        t.sublookup.to_a(:leaves)
      ).to eq(
        [ :num, 1, 0, 1, nil, :rex, '4' ]
      )
    end
  end

  describe '.gather' do

    it 'returns all the nodes with a given name' do

      t = Sample::Cal.parse('4 5 6 + 1 2 3 * +', rewrite: false)

      expect(
        t.gather('op').collect { |n| n.to_a(:leaves) }
      ).to eq(
        [ [ :op, 1, 6, 1, nil, :rex, '+' ],
          [ :op, 1, 14, 1, nil, :rex, '*' ],
          [ :op, 1, 16, 1, nil, :rex, '+' ] ]
      )
    end

    it 'returns all the nodes with a name if the given name is nil' do

      t = Sample::Cal.parse('4 5 6 + 1 2 3 * +', rewrite: false)

      expect(
        t.gather.collect { |n| n.to_a(:leaves) }
      ).to eq([
        [ :item, 1, 0, 1, nil, :alt, [
          [ :num, 1, 0, 1, nil, :rex, '4' ] ] ],
        [ :item, 1, 2, 1, nil, :alt, [
          [ :num, 1, 2, 1, nil, :rex, '5' ] ] ],
        [ :item, 1, 4, 1, nil, :alt, [
          [ :num, 1, 4, 1, nil, :rex, '6' ] ] ],
        [ :item, 1, 6, 1, nil, :alt, [
          [ :op, 1, 6, 1, nil, :rex, '+' ] ] ],
        [ :item, 1, 8, 1, nil, :alt, [
          [ :num, 1, 8, 1, nil, :rex, '1' ] ] ],
        [ :item, 1, 10, 1, nil, :alt, [
          [ :num, 1, 10, 1, nil, :rex, '2' ] ] ],
        [ :item, 1, 12, 1, nil, :alt, [
          [ :num, 1, 12, 1, nil, :rex, '3' ] ] ],
        [ :item, 1, 14, 1, nil, :alt, [
          [ :op, 1, 14, 1, nil, :rex, '*' ] ] ],
        [ :item, 1, 16, 1, nil, :alt, [
          [ :op, 1, 16, 1, nil, :rex, '+' ] ] ]
      ])
    end
  end

  describe '.subgather' do

    it 'skips the callee node' do

      t = Sample::Cal.parse('4 5 6 + 1 2 3 * +', rewrite: false)

      expect(
        t.children[0].subgather.collect { |n| n.to_a(:leaves) }
      ).to eq([
        [ :num, 1, 0, 1, nil, :rex, '4' ]
      ])
    end
  end

  describe '.string' do

    it 'returns the string covered by the tree' do

      t = Sample::Arith.parse('11 + 12', rewrite: false)

#Raabro.pp(t, colours: true)
      expect(t.string).to eq('11 + 12')
      expect(t.sublookup(:number).string).to eq('11 ')
      expect(t.sublookup(:plus).string).to eq('+ ')
    end
  end

  describe '.strinp' do

    it 'returns the string covered by the tree by stripped' do

      t = Sample::Arith.parse('11 + 13', rewrite: false)

#Raabro.pp(t, colours: true)
      expect(t.strinp).to eq('11 + 13')
      expect(t.sublookup(:number).strinp).to eq('11')
      expect(t.sublookup(:plus).strinp).to eq('+')
    end
  end
end

