
#
# A sample raabro parser/rewriter
#
# Thu Sep 24 06:18:57 JST 2015
#

require 'raabro'


module Fun include Raabro

  # parse
  #
  # Last function is the root, "i" stands for "input".

  def pa(i); rex(nil, i, /\(\s*/); end
  def pz(i); rex(nil, i, /\)\s*/); end
  def com(i); rex(nil, i, /,\s*/); end

  def num(i); rex(:num, i, /-?[0-9]+\s*/); end

  def args(i); eseq(nil, i, :pa, :exp, :com, :pz); end
  def funame(i); rex(nil, i, /[a-z][a-z0-9]*/); end
  def fun(i); seq(:fun, i, :funame, :args); end

  def exp(i); alt(nil, i, :fun, :num); end

  # rewrite
  #
  # Names above (:num, :fun, ...) get a rewrite_xxx function.
  # "t" stands for "tree".
  #
  # The trees with a nil name are handled by rewrite_(tree) a default
  # rewrite function

  def rewrite_num(t); t.string.to_i; end

  def rewrite_fun(t)
    [ t.children[0].string ] +
    t.children[1].odd_children.collect { |a| rewrite(a) }
  end
end


p Fun.parse('mul(1, 2)')
  # => ["mul", 1, 2]

p Fun.parse('mul(1, add(-2, 3))')
  # => ["mul", 1, ["add", -2, 3]]

p Fun.parse('mul (1, 2)')
  # => nil (doesn't accept a space after the function name)

