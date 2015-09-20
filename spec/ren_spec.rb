
#
# specifying raabro
#
# Mon Sep 21 05:46:00 JST 2015
#

require 'spec_helper'


describe Raabro do

  describe '.ren' do

    it 'returns the tree coming from the wrapped parser' do

      i = Raabro::Input.new('ta')

      t = Raabro.ren('renamed', i, :nta)

      expect(t.to_a(:leaves => true)).to eq(
        [ 'renamed', 1, 0, 2, nil, :str, 'ta' ]
      )
      expect(i.offset).to eq(2)
    end
  end

  describe '.rename' do

    it 'is an alias to .ren' do

      i = Raabro::Input.new('ta')

      t = Raabro.rename('autre', i, :nta)

      expect(t.to_a(:leaves => true)).to eq(
        [ 'autre', 1, 0, 2, nil, :str, 'ta' ]
      )
      expect(i.offset).to eq(2)
    end
  end
end

