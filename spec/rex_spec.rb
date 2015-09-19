
#
# specifying raabro
#
# Sun Sep 20 07:12:35 JST 2015
#

require 'spec_helper'


describe Raabro do

  before :each do

    @input = Raabro::Input.new('toto')
  end

  describe '.rex' do

    it 'returns a tree with result == 0 in case of failure' do

      t = Raabro.rex(nil, @input, /t[ua]/)

      expect(t.to_a).to eq(
        [ nil, 0, 0, 0, nil, :rex, [] ]
      )
      expect(@input.offset).to eq(0)
    end

    it "returns a tree with result == 1 in case of success" do

      t = Raabro.rex(nil, @input, /(to)+/)

      expect(t.to_a(:leaves => true)).to eq(
        [ nil, 1, 0, 4, nil, :rex, 'toto' ]
      )
      expect(@input.offset).to eq(4)
    end
  end
end

