
# raabro

[![Build Status](https://secure.travis-ci.org/jmettraux/raabro.png)](http://travis-ci.org/jmettraux/raabro)
[![Gem Version](https://badge.fury.io/rb/raabro.png)](http://badge.fury.io/rb/raabro)

A very dumb PEG parser library.

Son to [aabro](https://github.com/flon-io/aabro), grandson to [neg](https://github.com/jmettraux/neg), grand-grandson to [parslet](https://github.com/kschiess/parslet).


## a sample parser/rewriter

You use raabro by providing the parsing rules, then some rewrite rules.

The parsing rules make use of the raabro basic parsers `seq`, `alt`, `str`, `rex`, `eseq`, ...

The rewrite rules match names passed as first argument to the basic parsers to rewrite the resulting parse trees.

```ruby
require 'raabro'


module Fun include Raabro

  # parse
  #
  # Last function is the root, "i" stands for "input".

  def pa(i); rex(nil, i, /\(\s*/); end
  def pz(i); rex(nil, i, /\)\s*/); end
  def com(i); rex(nil, i, /,\s*/); end

  def num(i); rex(:num, i, /-?[0-9]+\s*/); end

  def args(i); eseq(:args, i, :pa, :exp, :com, :pz); end
  def funame(i); rex(:funame, i, /[a-z][a-z0-9]*/); end
  def fun(i); seq(:fun, i, :funame, :args); end

  def exp(i); alt(:exp, i, :fun, :num); end

  # rewrite
  #
  # Names above (:num, :fun, ...) get a rewrite_xxx function.
  # "t" stands for "tree".

  def rewrite_exp(t); rewrite(t.children[0]); end
  def rewrite_num(t); t.string.to_i; end

  def rewrite_fun(t)
    [ t.children[0].string ] +
    t.children[1].children.inject([]) { |a, e| a << rewrite(e) if e.name; a }
  end
end


p Fun.parse('mul(1, 2)')
  # => ["mul", 1, 2]

p Fun.parse('mul(1, add(-2, 3))')
  # => ["mul", 1, ["add", -2, 3]]

p Fun.parse('mul (1, 2)')
  # => nil (doesn't accept a space after the function name)
```

This sample is available at: [doc/readme0.rb](doc/readme0.rb).


## basic parsers

The first parameter is the name used by rewrite rules.
The second parameter is a `Raabro::Input` instance, mostly a wrapped string.

```ruby
def seq(name, input, *parsers)
  # a sequence of parsers

def alt(name, input, *parsers)
  # tries the parsers returns as soon as one succeeds

def altg(name, input, *parsers)
  # tries all the parsers, returns with the longest match

def rep(name, input, parser, min, max=0)
  # repeats the the wrapped parser

def ren(name, input, parser)
  # renames the output of the wrapped parser

def jseq(name, input, eltpa, seppa)
  # seq(name, input, eltpa, seppa, eltpa, seppa, eltpaa, seppa, ...)

def eseq(name, input, startpa, eltpa, seppa, endpa)
  # seq(name, input, startpa, eltpa, seppa, eltpa, seppa, ..., endpa)
```


## LICENSE

MIT, see [LICENSE.txt](LICENSE.txt)

