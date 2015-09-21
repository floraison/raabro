
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

    context 'when not greedy (default)' do

      it 'goes with the first successful result' do

        i = Raabro::Input.new('xx')

        t = Raabro.alt(nil, i, :onex, :twox)

        expect(t.to_a(:leaves => true)).to eq(
          [ nil, 1, 0, 1, nil, :alt, [
            [ :onex, 1, 0, 1, nil, :str, 'x' ]
          ] ]
        )
        expect(i.offset).to eq(1)
      end
    end

    context 'when greedy (last argument set to true)' do

      it 'takes the longest successful result' do

        i = Raabro::Input.new('xx')

        t = Raabro.alt(nil, i, :onex, :twox, true)

        expect(t.to_a(:leaves => true)).to eq(
          [ nil, 1, 0, 2, nil, :alt, [
            [ :onex, 0, 0, 1, nil, :str, [] ],
            [ :twox, 1, 0, 2, nil, :str, 'xx' ]
          ] ]
        )
        expect(i.offset).to eq(2)
      end
    end
  end
end

