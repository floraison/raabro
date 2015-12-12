
#
# specifying raabro
#
# Sun Dec 13 06:10:00 JST 2015
#

require 'spec_helper'


module Sample::Xell include Raabro

  # parse

  def pa(i); str(nil, i, '('); end
  def pz(i); str(nil, i, ')'); end
  def com(i); str(nil, i, ','); end

  def num(i); rex(:num, i, /-?[0-9]+/); end

  def args(i); eseq(nil, i, :pa, :exp, :com, :pz); end
  def funame(i); rex(nil, i, /[A-Z][A-Z0-9]*/); end
  def fun(i); seq(:fun, i, :funame, :args); end

  def exp(i); alt(nil, i, :fun, :num); end

  # rewrite

  def rewrite_(t) # shouldn't that be part of raabro?

    c = t.children.find { |c| c.length > 0 || c.name }
    c ? rewrite(c) : nil
  end

  def rewrite_num(t); t.string.to_i; end

  def rewrite_fun(t)

    #as = []
    #t.children[1].children.each_with_index { |e, i| as << e if i.odd? }
    #[ t.children[0].string ] + as.collect { |a| rewrite(a) }
    [ t.children[0].string ] +
    t.children[1].odd_children.collect { |a| rewrite(a) }
  end
end


describe Raabro do

  describe Sample::Xell do

    describe '.parse' do

      it 'parses (success)' do

        expect(
          Sample::Xell.parse('MUL(7,-3)')
        ).to eq(
          [ 'MUL', 7, -3 ]
        )
      end

      it 'parses (rewrite: false, success)' do

        expect(
          Sample::Xell.parse('MUL(7,-3)', rewrite: false).to_s
        ).to eq(%{
1 nil 0,9
  1 :fun 0,9
    1 nil 0,3 "MUL"
    1 nil 3,6
      1 nil 3,1 "("
      1 nil 4,1
        1 :num 4,1 "7"
      1 nil 5,1 ","
      1 nil 6,2
        1 :num 6,2 "-3"
      1 nil 8,1 ")"
        }.strip)
      end

      it 'parses (miss)' do

        expect(Sample::Xell.parse('MUL(7,3) ')).to eq(nil)
        expect(Sample::Xell.parse('MUL(7,3')).to eq(nil)
      end
    end
  end
end

