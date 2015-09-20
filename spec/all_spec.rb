
#
# specifying raabro
#
# Mon Sep 21 05:56:18 JST 2015
#

require 'spec_helper'


describe Raabro do

  describe '.all' do

    it 'fails when not all the input is consumed' do

      i = Raabro::Input.new('tototota')

      t = Raabro.all(nil, i, :to_plus)

      expect(t.to_a(:leaves => true)).to eq(
        [ nil, 0, 0, 0, nil, :all, [
          [ :tos, 1, 0, 6, nil, :rep, [
            [ nil, 1, 0, 2, nil, :str, 'to' ],
            [ nil, 1, 2, 2, nil, :str, 'to' ],
            [ nil, 1, 4, 2, nil, :str, 'to' ],
            [ nil, 0, 6, 0, nil, :str, [] ]
          ] ]
        ] ]
      )
      expect(i.offset).to eq(0)
    end

    it 'succeeds when all the input is consumed' do

      i = Raabro::Input.new('tototo')

      t = Raabro.all(nil, i, :to_plus)

      expect(t.to_a(:leaves => true)).to eq(
        [ nil, 1, 0, 6, nil, :all, [
          [ :tos, 1, 0, 6, nil, :rep, [
            [ nil, 1, 0, 2, nil, :str, 'to' ],
            [ nil, 1, 2, 2, nil, :str, 'to' ],
            [ nil, 1, 4, 2, nil, :str, 'to' ],
            [ nil, 0, 6, 0, nil, :str, [] ]
          ] ]
        ] ]
      )
      expect(i.offset).to eq(6)
    end
  end
end

