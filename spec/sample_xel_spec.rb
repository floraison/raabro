
#
# specifying raabro
#
# Mon Sep 21 16:58:01 JST 2015
#

require 'spec_helper'


module Sample::Xel include Raabro

  # parse

  def pa(i); str(nil, i, '('); end
  def pz(i); str(nil, i, ')'); end
  def com(i); str(nil, i, ','); end

  def num(i); rex(:num, i, /-?[0-9]+/); end

  def args(i); eseq(:args, i, :pa, :exp, :com, :pz); end
  def funame(i); rex(:funame, i, /[A-Z][A-Z0-9]*/); end
  def fun(i); seq(:fun, i, :funame, :args); end

  def exp(i); alt(:exp, i, :fun, :num); end

  #alias root exp
    # not necessary since Raabro takes the last defined parser as the root

  # rewrite

  def rewrite_exp(t); rewrite(t.children[0]); end
  def rewrite_num(t); t.string.to_i; end

  def rewrite_fun(t)

    #[ t.children[0].string ] +
    #t.children[1].children.inject([]) { |a, e| a << rewrite(e) if e.name; a }
    [ t.children[0].string ] + t.children[1].odd_children.map { |c| rewrite(c) }
  end
end


describe Raabro do

  describe Sample::Xel do

    describe '.funame' do

      it 'hits' do

        i = Raabro::Input.new('NADA')

        t = Sample::Xel.funame(i)

        expect(t.to_a(:leaves => true)).to eq(
          [ :funame, 1, 0, 4, nil, :rex, 'NADA' ]
        )
      end
    end

    describe '.fun' do

      it 'parses a function call' do

        i = Raabro::Input.new('SUM(1,MUL(4,5))', :prune => true)

        t = Sample::Xel.fun(i)

        expect(t.result).to eq(1)

        expect(
          Sample::Xel.rewrite(t)
        ).to eq(
          [ 'SUM', 1, [ 'MUL', 4, 5 ] ]
        )
      end
    end

    describe '.parse' do

      it 'parses (success)' do

        expect(
          Sample::Xel.parse('MUL(7,-3)')
        ).to eq(
          [ 'MUL', 7, -3 ]
        )
      end

      it 'parses (rewrite: false, success)' do

        expect(
          Sample::Xel.parse('MUL(7,-3)', rewrite: false).to_s
        ).to eq(%{
1 :exp 0,9
  1 :fun 0,9
    1 :funame 0,3 "MUL"
    1 :args 3,6
      1 nil 3,1 "("
      1 :exp 4,1
        1 :num 4,1 "7"
      1 nil 5,1 ","
      1 :exp 6,2
        1 :num 6,2 "-3"
      1 nil 8,1 ")"
        }.strip)
      end

      it 'parses (miss)' do

        expect(Sample::Xel.parse('MUL(7,3) ')).to eq(nil)
        expect(Sample::Xel.parse('MUL(7,3')).to eq(nil)
      end

      it 'parses (miss with error: true)' do

        expect(
          Sample::Xel.parse('MUL(7,3', error: true)
        ).to eq(
          [ 1, 8, 7, 'parsing failed .../:exp/:fun/:args',
            "MUL(7,3\n" +
            "       ^---" ]
        )
      end

      it 'parses (success)' do

        s = 'MUL(2' + ',2' * 20_000 + ')'
        t, d = do_time { Sample::Xel.parse(s, error: true) }

        expect(t).not_to eq(nil)

        expect(d).to be < 7
          #
          # 0.836 on i7-1165G7 32G
          #
          # OK at 2.1 for GitHub CI
          #   expect for Ruby 2.3 which reaches 2.394s
          #   expect for TruffleRuby 22.3 which reaches 4.771s
      end
    end
  end
end

