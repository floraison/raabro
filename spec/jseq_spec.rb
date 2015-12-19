
#
# specifying raabro
#
# Mon Sep 21 06:55:35 JST 2015
#

require 'spec_helper'


describe Raabro do

  describe '.jseq' do

    it 'parses elts joined by a separator' do

      i = Raabro::Input.new('a,b,c')

      t = Raabro.jseq(:j, i, :cha, :com)

      expect(t.to_a(:leaves => true)).to eq(
        [ :j, 1, 0, 5, nil, :jseq, [
          [ nil, 1, 0, 1, nil, :rex, 'a' ],
          [ nil, 1, 1, 1, nil, :str, ',' ],
          [ nil, 1, 2, 1, nil, :rex, 'b' ],
          [ nil, 1, 3, 1, nil, :str, ',' ],
          [ nil, 1, 4, 1, nil, :rex, 'c' ]
        ] ]
      )
      expect(i.offset).to eq(5)
    end

    it 'prunes' do

      i = Raabro::Input.new('a,b,c', :prune => true)

      t = Raabro.jseq(:j, i, :cha, :com)

      expect(t.to_a(:leaves => true)).to eq(
        [ :j, 1, 0, 5, nil, :jseq, [
          [ nil, 1, 0, 1, nil, :rex, 'a' ],
          [ nil, 1, 1, 1, nil, :str, ',' ],
          [ nil, 1, 2, 1, nil, :rex, 'b' ],
          [ nil, 1, 3, 1, nil, :str, ',' ],
          [ nil, 1, 4, 1, nil, :rex, 'c' ]
        ] ]
      )
      expect(i.offset).to eq(5)
    end

    it 'fails when zero elements' do

      i = Raabro::Input.new('')

      t = Raabro.jseq(:j, i, :cha, :com)

      expect(t.to_a(:leaves => true)).to eq(
        [ :j, 0, 0, 0, nil, :jseq, [] ]
      )
      expect(i.offset).to eq(0)
    end
  end
end

