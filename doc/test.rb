
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

  def pstart(i); rex(nil, i, /\(\s*/); end
  def pend(i); rex(nil, i, /\)\s*/); end
    # parenthese start and end, including trailing white space

  def comma(i); rex(nil, i, /,\s*/); end
    # a comma, including trailing white space

  def num(i); rex(:num, i, /-?[0-9]+\s*/); end
    # name is :num, a positive or negative integer

  def args(i); eseq(nil, i, :pstart, :exp, :comma, :pend); end
    # a set of :exp, beginning with a (, punctuated by commas and ending with )

  def funame(i); rex(nil, i, /[a-z][a-z0-9]*/); end
  def fun(i); seq(:fun, i, :funame, :args); end
    # name is :fun, a function composed of a function name
    # followed by arguments

  def exp(i); alt(nil, i, :fun, :num); end
    # an expression is either (alt) a function or a number

  # rewrite
  #
  # Names above (:num, :fun, ...) get a rewrite_xxx function.
  # "t" stands for "tree".

  def rewrite_exp(t); rewrite(t.children[0]); end
  def rewrite_num(t); t.string.to_i; end

  def rewrite_fun(t)

    funame, args = t.children

    [ funame.string ] +
    args.gather.collect { |e| rewrite(e) }
      #
      # #gather collect all the children in a tree that have
      # a name, in this example, names can be :exp, :num, :fun
  end
end

p Fun.parse('mul(1, 2)')
  # => ["mul", 1, 2]
p Fun.parse('mul(1, add(-2, 3))')
  # => ["mul", 1, ["add", -2, 3]]
p Fun.parse('mul (1, 2)')
  # => nil (doesn't accept a space after the function name)

