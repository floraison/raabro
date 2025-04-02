
#
# specifying raabro
#
# Thu Aug 10 07:52:29 JST 2017
#


module Sample::ToPlus include Raabro

  # parse

  def sp_star(i); rex(nil, i, /\s*/);end
  def to_space(i); seq(nil, i, :to, :sp_star); end
  def to_plus(i); rep(:tos, i, :to_space, 1); end

  # rewrite

  def rewrite(t)

    [ :ok, t.string ]
  end
end

module Sample::Fun include Raabro

  # parse
  #
  # Last function is the root, "i" stands for "input".

  def pa(i); rex(nil, i, /\(\s*/); end
  def pz(i); rex(nil, i, /\)\s*/); end
  def com(i); rex(nil, i, /,\s*/); end

  def num(i); rex(:num, i, /-?[0-9]+\s*/); end

  def args(i); eseq(:arg, i, :pa, :exp, :com, :pz); end
  def funame(i); rex(:funame, i, /[a-z][a-z0-9]*/); end
  def fun(i); seq(:fun, i, :funame, :args); end

  def exp(i); alt(:exp, i, :fun, :num); end

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


group 'Raabro and parse failure' do

  group 'when there is a syntax error' do

    test 'points at the error' do

      t = Sample::Fun.parse('f(a, b')
      assert t, nil

      assert(
        Sample::Fun.parse('f(a, b', error: true),
        [ 1, 4, 3, 'parsing failed .../:exp/:fun/:arg', "f(a, b\n   ^---" ])
    end
  end

  group 'when not all is consumed' do

    test 'points at the start of the remaining input' do

      t = Sample::ToPlus.parse('totota')
      assert t, nil

      assert(
        Sample::ToPlus.parse('totota', error: true),
        [ 1, 5, 4,
          'parsing failed, not all input was consumed',
          "totota\n    ^---" ])
    end

    test 'points at the start of the remaining input (multiline)' do

      s = "toto\r\n  ta"

      t = Sample::ToPlus.parse(s)
      assert t, nil

      assert(
        Sample::ToPlus.parse(s, error: true),
        [ 2, 3, 8,
          'parsing failed, not all input was consumed',
          "  ta\n  ^---" ])
    end
  end
end

