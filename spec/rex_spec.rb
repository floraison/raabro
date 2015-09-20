
#
# specifying raabro
#
# Sun Sep 20 07:12:35 JST 2015
#

require 'spec_helper'


describe Raabro do

  describe '.rex' do

    it 'returns a tree with result == 0 in case of failure' do

      i = Raabro::Input.new('toto')

      t = Raabro.rex(nil, i, /t[ua]/)

      expect(t.to_a).to eq(
        [ nil, 0, 0, 0, nil, :rex, [] ]
      )
      expect(i.offset).to eq(0)
    end

    it "returns a tree with result == 1 in case of success" do

      i = Raabro::Input.new('toto')

      t = Raabro.rex(nil, i, /(to)+/)

      expect(t.to_a(:leaves => true)).to eq(
        [ nil, 1, 0, 4, nil, :rex, 'toto' ]
      )
      expect(i.offset).to eq(4)
    end
  end
end

