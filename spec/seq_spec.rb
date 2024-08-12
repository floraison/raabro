
#
# specifying raabro
#
# Sun Sep 20 06:11:54 JST 2015
#

require 'spec_helper'


describe Raabro do

  describe '.seq' do

    it "returns a tree with result == 0 in case of failure" do

      i = Raabro::Input.new('tato')

      t = Raabro.seq(nil, i, :to, :ta)

      expect(t.to_a).to eq(
        [ nil, 0, 0, 0, nil, :seq, [
          [ nil, 0, 0, 0, nil, :str, [] ]
        ] ]
      )
      expect(i.offset).to eq(0)
    end

    it "returns a tree with result == 0 in case of failure (at 2nd step)" do

      i = Raabro::Input.new('tato')

      t = Raabro.seq(nil, i, :ta, :ta)

      expect(
        t.to_a(:leaves => true)
      ).to eq(
        [ nil, 0, 0, 0, nil, :seq, [
          [ nil, 1, 0, 2, nil, :str, 'ta' ],
          [ nil, 0, 2, 0, nil, :str, [] ]
        ] ]
      )
      expect(i.offset).to eq(0)
    end

    it "returns a tree with result == 1 in case of success" do

      i = Raabro::Input.new('tato')

      t = Raabro.seq(nil, i, :ta, :to)

      expect(
        t.to_a(:leaves => true)
      ).to eq(
        [ nil, 1, 0, 4, nil, :seq, [
          [ nil, 1, 0, 2, nil, :str, 'ta' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ]
        ] ]
      )
      expect(i.offset).to eq(4)
    end

    it "names the result if there is a name" do

      i = Raabro::Input.new('tato')

      t = Raabro.seq(:x, i, :ta, :to)

      expect(
        t.to_a(:leaves => true)
      ).to eq(
        [ :x, 1, 0, 4, nil, :seq, [
          [ nil, 1, 0, 2, nil, :str, 'ta' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ]
        ] ]
      )
      expect(i.offset).to eq(4)
    end

    it "names in case of failure as well" do

      i = Raabro::Input.new('tato')

      t = Raabro.seq(:y, i, :ta, :ta)

      expect(
        t.to_a(:leaves => true)
      ).to eq(
        [ :y, 0, 0, 0, nil, :seq, [
          [ nil, 1, 0, 2, nil, :str, 'ta' ],
          [ nil, 0, 2, 0, nil, :str, [] ]
        ] ]
      )
      expect(i.offset).to eq(0)
    end

    it "fails when the input string ends" do

      i = Raabro::Input.new('to')

      t = Raabro.seq(:z, i, :to, :ta)

      expect(
        t.to_a(:leaves => true)
      ).to eq(
        [ :z, 0, 0, 0, nil, :seq, [
          [ nil, 1, 0, 2, nil, :str, 'to' ],
          [ nil, 0, 2, 0, nil, :str, [] ]
        ] ]
      )
      expect(i.offset).to eq(0)
    end

    it "accepts an empty input" do

      i = Raabro::Input.new('tato', 4)

      t = Raabro.seq(nil, i, :to, :ta)

      expect(t.to_a).to eq(
        [ nil, 0, 4, 0, nil, :seq, [
          [ nil, 0, 4, 0, nil, :str, [] ]
        ] ]
      )
      expect(i.offset).to eq(4)
    end

    it 'returns as soon as the job is done' do

      i = Raabro::Input.new('to' * 10_000)

      t, d = do_time { Raabro.seq(:twotoes, i, :to, :to) }

      expect(t.to_a(leaves: true)).to eq(
        [ :twotoes, 1, 0, 4, nil, :seq, [
          [ nil, 1, 0, 2, nil, :str, 'to' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ] ] ]
      )

      expect(d).to be < 0.2 # seconds
    end
  end

  describe 'seq and quantifiers' do

    describe 'a lonely quantifier' do

      it 'raises an ArgumentError' do

        i = Raabro::Input.new('tato')

        expect {
          t = Raabro.seq(nil, i, '?')
        }.to raise_error(ArgumentError, 'lone quantifier ?')
      end
    end

    describe 'the question mark quantifier' do

      it 'lets optional elements appear in sequences (miss)' do

        i = Raabro::Input.new('tato')

        t = Raabro.seq(nil, i, :ta, :tu, '?', :to)

        expect(t.to_a(:leaves => true)).to eq(
          [ nil, 1, 0, 4, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 0, 2, 0, nil, :str, [] ],
            [ nil, 1, 2, 2, nil, :str, 'to' ]
          ] ]
        )
        expect(i.offset).to eq(4)
      end

      it 'lets optional elements appear in sequences (hit)' do

        i = Raabro::Input.new('tatuto')

        t = Raabro.seq(nil, i, :ta, :tu, '?', :to)

        expect(t.to_a(:leaves => true)).to eq(
          [ nil, 1, 0, 6, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 1, 2, 2, nil, :str, 'tu' ],
            [ nil, 1, 4, 2, nil, :str, 'to' ]
          ] ]
        )
        expect(i.offset).to eq(6)
      end

      it 'lets optional elements appear in sequences (fail)' do

        i = Raabro::Input.new('tatututo')

        t = Raabro.seq(nil, i, :ta, :tu, '?', :to)

        expect(t.to_a(:leaves => true)).to eq(
          [ nil, 0, 0, 0, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 1, 2, 2, nil, :str, 'tu' ],
            [ nil, 0, 4, 0, nil, :str, [] ]
          ] ]
        )
        expect(i.offset).to eq(0)
      end
    end

    describe 'the star quantifier' do

      it 'lets optional elements recur in sequences (hit zero)' do

        i = Raabro::Input.new('tato')

        t = Raabro.seq(nil, i, :ta, :tu, '*', :to)

        expect(t.to_a(:leaves => true)).to eq(
          [ nil, 1, 0, 4, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 0, 2, 0, nil, :str, [] ],
            [ nil, 1, 2, 2, nil, :str, 'to' ]
          ] ]
        )
        expect(i.offset).to eq(4)
      end

      it 'lets optional elements recur in sequences (hit)' do

        i = Raabro::Input.new('tatututo')

        t = Raabro.seq(nil, i, :ta, :tu, '*', :to)

        expect(t.to_a(:leaves => true)).to eq(
          [ nil, 1, 0, 8, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 1, 2, 2, nil, :str, 'tu' ],
            [ nil, 1, 4, 2, nil, :str, 'tu' ],
            [ nil, 0, 6, 0, nil, :str, [] ],
            [ nil, 1, 6, 2, nil, :str, 'to' ]
          ] ]
        )
        expect(i.offset).to eq(8)
      end

      it 'stops when there is no progress' do

        i = Raabro::Input.new('abc')

        t = Raabro.seq(nil, i, :to_star, '*');

        expect(t.to_a(:leaves => true)).to eq(
          [ nil, 1, 0, 0, nil, :seq, [
            [ nil, 1, 0, 0, nil, :rep, [
              [ nil, 0, 0, 0, nil, :str, [] ]
            ] ]
          ] ]
        )
      end
    end

    describe 'the plus quantifier' do

      it 'lets elements recur in sequences (hit)' do

        i = Raabro::Input.new('tatututo')

        t = Raabro.seq(nil, i, :ta, :tu, '+', :to)

        expect(t.to_a(:leaves => true)).to eq(
          [ nil, 1, 0, 8, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 1, 2, 2, nil, :str, 'tu' ],
            [ nil, 1, 4, 2, nil, :str, 'tu' ],
            [ nil, 0, 6, 0, nil, :str, [] ],
            [ nil, 1, 6, 2, nil, :str, 'to' ]
          ] ]
        )
        expect(i.offset).to eq(8)
      end

      it 'lets elements recur in sequences (fail)' do

        i = Raabro::Input.new('tato')

        t = Raabro.seq(nil, i, :ta, :tu, '+', :to)

        expect(t.to_a(:leaves => true)).to eq(
          [ nil, 0, 0, 0, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 0, 2, 0, nil, :str, [] ]
          ] ]
        )
        expect(i.offset).to eq(0)
      end

      it 'stops when there is no progress' do

        i = Raabro::Input.new('abc')

        t = Raabro.seq(nil, i, :to_star, '+');

        expect(t.to_a(:leaves => true)).to eq(
          [ nil, 1, 0, 0, nil, :seq, [
            [ nil, 1, 0, 0, nil, :rep, [
              [ nil, 0, 0, 0, nil, :str, [] ]
            ] ]
          ] ]
        )
      end
    end

    describe 'the exclamation mark' do

      it 'throws an error when lonely' do

        i = Raabro::Input.new('tato')

        expect {
          t = Raabro.seq(nil, i, '!')
        }.to raise_error(ArgumentError, 'lone quantifier !')
      end

      it 'hits post' do

        i = Raabro::Input.new('tatu')

        t = Raabro.seq(nil, i, :ta, :ta, '!')

        expect(t.to_a(leaves: true)).to eq(
          [ nil, 1, 0, 2, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 1, 2, 0, nil, :nott, [
              [ nil, 0, 2, 0, nil, :str, [] ] ] ] ] ]
        )
        expect(i.offset).to eq(2)
      end

      it 'misses post' do

        i = Raabro::Input.new('tata')

        t = Raabro.seq(nil, i, :ta, :ta, '!')

        expect(t.to_a(leaves: true)).to eq(
          [ nil, 0, 0, 0, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 0, 2, 0, nil, :nott, [
              [ nil, 1, 2, 2, nil, :str, 'ta' ] ] ] ] ]
        )
        expect(i.offset).to eq(0)
      end

      it 'hits pre' do

        i = Raabro::Input.new('tatu')

        t = Raabro.seq(nil, i, :tu, '!', :ta, :tu)

        expect(t.to_a(leaves: true)).to eq(
          [ nil, 1, 0, 4, nil, :seq, [
            [ nil, 1, 0, 0, nil, :nott, [
              [ nil, 0, 0, 0, nil, :str, [] ] ] ],
              [ nil, 1, 0, 2, nil, :str, 'ta' ],
              [ nil, 1, 2, 2, nil, :str, 'tu' ] ] ]
        )
        expect(i.offset).to eq(4)
      end

      it 'misses pre' do

        i = Raabro::Input.new('tutu')

        t = Raabro.seq(nil, i, :tu, '!', :ta, :tu)

        expect(t.to_a(leaves: true)).to eq(
          [ nil, 0, 0, 0, nil, :seq, [
            [ nil, 0, 0, 0, nil, :nott, [
              [ nil, 1, 0, 2, nil, :str, 'tu' ] ] ] ] ]
        )
        expect(i.offset).to eq(0)
      end
    end
  end
end

