
#
# specifying raabro
#
# Sun Sep 20 09:36:16 JST 2015
#

require 'spec_helper'


describe Raabro do

  before :each do

    @input = Raabro::Input.new('toto')
  end

  describe '.rep' do

    it 'returns a tree with result == 0 in case of failure' do

      t = Raabro.rep(:x, @input, :to, 3, 4)

      expect(t.to_a(:leaves => true)).to eq(
        [ :x, 0, 0, 0, nil, :rep, [
          [ nil, 1, 0, 2, nil, :str, 'to' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ],
          [ nil, 0, 4, 0, nil, :str, [] ]
        ] ]
      )
      expect(@input.offset).to eq(0)
    end

    it "succeeds (max reached)" do

      t = Raabro.rep(:x, @input, :to, 1, 2)

      expect(t.to_a(:leaves => true)).to eq(
        [ :x, 1, 0, 4, nil, :rep, [
          [ nil, 1, 0, 2, nil, :str, 'to' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ]
        ] ]
      )
      expect(@input.offset).to eq(4)
    end

    it "succeeds (min reached)"
  end
end

