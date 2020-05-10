
#
# specifying raabro
#
# Sun May 10 13:45:35 JST 2020
#

require 'spec_helper'


describe Raabro do

  describe '.nott' do

    it 'hits' do

      i = Raabro::Input.new('to')
      t = Raabro.nott(:no0, i, :ta)

      expect(t.to_a(leaves: true)).to eq(
        [ :no0, 1, 0, 0, nil, :nott, [
          [ nil, 0, 0, 0, nil, :str, [] ] ] ]
      )
      expect(i.offset).to eq(0)
    end

    it 'misses' do

      i = Raabro::Input.new('ta')
      t = Raabro.nott(:no0, i, :ta)

      expect(t.to_a(leaves: true)).to eq(
        [ :no0, 0, 0, 0, nil, :nott, [
          [ nil, 1, 0, 2, nil, :str, 'ta' ] ] ]
      )
      expect(i.offset).to eq(0)
    end
  end
end

