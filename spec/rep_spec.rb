
#
# specifying raabro
#
# Sun Sep 20 09:36:16 JST 2015
#

require 'spec_helper'


describe Raabro do

  describe '.rep' do

    it 'returns a tree with result == 0 in case of failure' do

      i = Raabro::Input.new('toto')

      t = Raabro.rep(:x, i, :to, 3, 4)

      expect(t.to_a(:leaves => true)).to eq(
        [ :x, 0, 0, 0, nil, :rep, [
          [ nil, 1, 0, 2, nil, :str, 'to' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ],
          [ nil, 0, 4, 0, nil, :str, [] ]
        ] ]
      )
      expect(i.offset).to eq(0)
    end

    it "fails (min not reached)" do

      i = Raabro::Input.new('toto')

      t = Raabro.rep(:x, i, :to, 3)

      expect(t.to_a(:leaves => true)).to eq(
        [ :x, 0, 0, 0, nil, :rep, [
          [ nil, 1, 0, 2, nil, :str, 'to' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ],
          [ nil, 0, 4, 0, nil, :str, [] ]
        ] ]
      )
      expect(i.offset).to eq(0)
    end

    it "succeeds (max set)" do

      i = Raabro::Input.new('tototo')

      t = Raabro.rep(:x, i, :to, 1, 2)

      expect(t.to_a(:leaves => true)).to eq(
        [ :x, 1, 0, 4, nil, :rep, [
          [ nil, 1, 0, 2, nil, :str, 'to' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ]
        ] ]
      )
      expect(i.offset).to eq(4)
    end

    it "succeeds (max not set)" do

      i = Raabro::Input.new('toto')

      t = Raabro.rep(:x, i, :to, 1)

      expect(t.to_a(:leaves => true)).to eq(
        [ :x, 1, 0, 4, nil, :rep, [
          [ nil, 1, 0, 2, nil, :str, 'to' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ],
          [ nil, 0, 4, 0, nil, :str, [] ]
        ] ]
      )
      expect(i.offset).to eq(4)
    end
  end
end

