
#
# specifying raabro
#
# Thu Aug 10 07:52:29 JST 2017
#

require 'spec_helper'


module Sample::Cal2 include Raabro

  # parse

  def sp(i); rex(nil, i, /\s+/); end

  def num(i); rex(:num, i, /-?[0-9]+/); end
  def op(i); rex(:op, i, /[+\-*\/]/); end
  def item(i); alt(:item, i, :num, :op); end

  def suite(i); jseq(:suite, i, :item, :sp); end

  # rewrite

  def rewrite_op(t); t.string.to_sym; end
  def rewrite_num(t); t.string.to_i; end
  def rewrite_item(t); rewrite(t.sublookup(nil)); end
  def rewrite_suite(t); t.subgather(:item).collect { |it| rewrite(it) }; end
end

module Sample::ToPlus include Raabro

  # parse

  def to_plus(input); rep(:tos, input, :to, 1); end

  # rewrite

  def rewrite(t)

    [ :ok, t.string ]
  end
end


describe 'Raabro and parse failure' do

  describe 'when there is a syntax error' do

    it 'points at the error' #do
#
#      input = '4 5 6+ 1 2 3 * +'
#
#      t = Sample::Cal2.parse(input)
#      expect(t).to eq(nil)
#
#      e = Sample::Cal2.parse(input, error: true)
#p e
#    end
  end

  describe 'when not all is consumed' do

    it 'points at the start of the remaining input'# do
#
#      t = Sample::ToPlus.parse('totota')
#      expect(t).to eq(nil)
#
#      err = Sample::ToPlus.parse('totota', error: true)
#p err
#    end
  end
end

