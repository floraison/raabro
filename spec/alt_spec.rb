
#
# specifying raabro
#
# Sun Sep 20 07:31:53 JST 2015
#

require 'spec_helper'


describe Raabro do

  describe '.alt' do

    before :each do

      @input = Raabro::Input.new('tato')
    end

    it "returns a tree with result == 0 in case of failure" do

      @input.string = 'tutu'

      t = Raabro.alt(nil, @input, :ta, :to)

      expect(t.to_a(:leaves => true)).to eq(
        [ nil, 0, 0, 0, nil, :alt, [
          [ nil, 0, 0, 0, nil, :str, [] ],
          [ nil, 0, 0, 0, nil, :str, [] ]
        ] ]
      )
      expect(@input.offset).to eq(0)
    end

    it "succeeds (1st alternative)" do

      t = Raabro.alt(nil, @input, :ta, :to)

      expect(t.to_a(:leaves => true)).to eq(
        [ nil, 1, 0, 2, nil, :alt, [
          [ nil, 1, 0, 2, nil, :str, 'ta' ]
        ] ]
      )
      expect(@input.offset).to eq(2)
    end

    it "succeeds (2nd alternative)" do

      t = Raabro.alt(nil, @input, :to, :ta)

      expect(t.to_a(:leaves => true)).to eq(
        [ nil, 1, 0, 2, nil, :alt, [
          [ nil, 0, 0, 0, nil, :str, [] ],
          [ nil, 1, 0, 2, nil, :str, 'ta' ]
        ] ]
      )
      expect(@input.offset).to eq(2)
    end
  end
end

