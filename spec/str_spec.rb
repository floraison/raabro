
#
# specifying raabro
#
# Sun Sep 20 06:11:54 JST 2015
#

require 'spec_helper'


describe Raabro do

  describe '.str' do

    it 'returns a tree with result == 0 in case of failure' do

      i = Raabro::Input.new('toto')

      t = Raabro.str(nil, i, 'nada')

      expect(t.to_a).to eq(
        [ nil, 0, 0, 0, nil, :str, [] ]
      )
      expect(i.offset).to eq(0)
    end

    it "returns a tree with result == 1 in case of success" do

      i = Raabro::Input.new('toto')

      t = Raabro.str(nil, i, 'toto')

      expect(t.to_a).to eq(
        [ nil, 1, 0, 4, nil, :str, [] ]
      )
      expect(i.offset).to eq(4)
    end

    it "names the result if there is a name" do

      i = Raabro::Input.new('toto')

      t = Raabro.str(:x, i, 'toto')

      expect(t.to_a).to eq(
        [ :x, 1, 0, 4, nil, :str, [] ]
      )
      expect(i.offset).to eq(4)
    end

    it "names in case of failure as well" do

      i = Raabro::Input.new('toto')

      t = Raabro.str(:y, i, 'nada')

      expect(t.to_a).to eq(
        [ :y, 0, 0, 0, nil, :str, [] ]
      )
      expect(i.offset).to eq(0)
    end

    it "accepts an empty input" do

      i = Raabro::Input.new('toto')
      i.offset = 4

      t = Raabro.str(nil, i, 'nada')

      expect(t.to_a).to eq(
        [ nil, 0, 4, 0, nil, :str, [] ]
      )
      expect(i.offset).to eq(4)
    end
  end
end

