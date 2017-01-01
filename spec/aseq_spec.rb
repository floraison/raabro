
#
# Specifying raabro
#
# Sun Jan  1 17:44:58 JST 2017  Ishinomaki
#

require 'spec_helper'


describe Raabro do

  describe '.aseq' do

    it 'fails if there are no elt parsers' do

      i = Raabro::Input.new('<whatever>')

      expect {
        Raabro.aseq(:arr, i, :lt, :gt, :com)
      }.to raise_error(
        ArgumentError, 'no elt parsers (aseq expects at least 6 args)'
      )
    end

    it 'parses successfully' do

      i = Raabro::Input.new('<ta,to,tu>')

      t = Raabro.aseq(:arr, i, :lt, :gt, :com, :ta, :to, :tu)

      expect(
        t.to_a(:leaves => true)
      ).to eq(
        [ :arr, 1, 0, 10, nil, :aseq, [
          [ nil, 1, 0, 1, nil, :str, '<' ],
          [ nil, 1, 1, 2, nil, :str, 'ta' ],
          [ nil, 1, 3, 1, nil, :str, ',' ],
          [ nil, 1, 4, 2, nil, :str, 'to' ],
          [ nil, 1, 6, 1, nil, :str, ',' ],
          [ nil, 1, 7, 2, nil, :str, 'tu' ],
          [ nil, 1, 9, 1, nil, :str, '>' ]
        ] ]
      )
      expect(i.offset).to eq(10)
    end

#    it 'prunes' do
#
#      i = Raabro::Input.new('<a,b>', :prune => true)
#
#      t = Raabro.eseq(:list, i, :lt, :cha, :com, :gt)
#
#      expect(t.to_a(:leaves => true)).to eq(
#        [ :list, 1, 0, 5, nil, :eseq, [
#          [ nil, 1, 0, 1, nil, :str, '<' ],
#          [ nil, 1, 1, 1, nil, :rex, 'a' ],
#          [ nil, 1, 2, 1, nil, :str, ',' ],
#          [ nil, 1, 3, 1, nil, :rex, 'b' ],
#          [ nil, 1, 4, 1, nil, :str, '>' ]
#        ] ]
#      )
#      expect(i.offset).to eq(5)
#    end
#
#    it 'parses <>' do
#
#      i = Raabro::Input.new('<>', :prune => true)
#
#      t = Raabro.eseq(:list, i, :lt, :cha, :com, :gt)
#
#      expect(t.to_a(:leaves => true)).to eq(
#        [ :list, 1, 0, 2, nil, :eseq, [
#          [ nil, 1, 0, 1, nil, :str, '<' ],
#          [ nil, 1, 1, 1, nil, :str, '>' ]
#        ] ]
#      )
#      expect(i.offset).to eq(2)
#    end
  end
end

