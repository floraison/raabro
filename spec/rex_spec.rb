
#
# specifying raabro
#
# Sun Sep 20 07:12:35 JST 2015
#

require 'spec_helper'


describe Raabro do

  describe '.rex' do

    it 'hits' do

      i = Raabro::Input.new('toto')

      t = Raabro.rex(nil, i, /t[ua]/)

      expect(t.to_a).to eq(
        [ nil, 0, 0, 0, nil, :rex, [] ]
      )
      expect(i.offset).to eq(0)
    end

    it 'misses' do

      i = Raabro::Input.new('toto')

      t = Raabro.rex(nil, i, /(to)+/)

      expect(t.to_a(:leaves => true)).to eq(
        [ nil, 1, 0, 4, nil, :rex, 'toto' ]
      )
      expect(i.offset).to eq(4)
    end

    it 'misses if the match is not at the current input offset' do

      i = Raabro::Input.new('tato')

      t = Raabro.rex(:biga, i, /(to)+/)

      expect(t.to_a(:leaves => true)).to eq(
        [ :biga, 0, 0, 0, nil, :rex, [] ]
      )
      expect(i.offset).to eq(0)
    end
  end
end

