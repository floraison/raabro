
# raabro

[![Build Status](https://secure.travis-ci.org/jmettraux/raabro.svg)](http://travis-ci.org/jmettraux/raabro)
[![Gem Version](https://badge.fury.io/rb/raabro.svg)](http://badge.fury.io/rb/raabro)

A very dumb PEG parser library.

Son to [aabro](https://github.com/flon-io/aabro), grandson to [neg](https://github.com/jmettraux/neg), grand-grandson to [parslet](https://github.com/kschiess/parslet). There is also a javascript version [jaabro](https://github.com/jmettraux/jaabro).


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
```

This sample is available at: [doc/readme0.rb](doc/readme0.rb).

## custom rewrite()

By default, a parser gets a `rewrite(t)` that looks at the parse tree node names and calls the corresponding `rewrite_{node_name}()`.

It's OK to provide a custom `rewrite(t)` function.

```ruby
module Hello include Raabro

  def hello(i); str(:hello, i, 'hello'); end

  def rewrite(t)
    [ :ok, t.string ]
  end
end
```


## basic parsers

One makes a parser by composing basic parsers, for example:
```ruby
  def args(i); eseq(:args, i, :pa, :exp, :com, :pz); end
  def funame(i); rex(:funame, i, /[a-z][a-z0-9]*/); end
  def fun(i); seq(:fun, i, :funame, :args); end
```
where the `fun` parser is a sequence combining the `funame` parser then the `args` one. `:fun` (the first argument to the basic parser `seq`) will be the name of the resulting (local) parse tree.

Below is a list of the basic parsers provided by Raabro.

The first parameter to the basic parser is the name used by rewrite rules.
The second parameter is a `Raabro::Input` instance, mostly a wrapped string.

```ruby
def str(name, input, string)
  # matching a string

def rex(name, input, regex_or_string)
  # matching a regexp
  # no need for ^ or \A, checks the match occurs at current offset

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
  #
  # seq(name, input, eltpa, seppa, eltpa, seppa, eltpaa, seppa, ...)
  #
  # a sequence of `eltpa` parsers separated (joined) by `seppa` parsers

def eseq(name, input, startpa, eltpa, seppa, endpa)
  #
  # seq(name, input, startpa, eltpa, seppa, eltpa, seppa, ..., endpa)
  #
  # a sequence of `eltpa` parsers separated (joined) by `seppa` parsers
  # preceded by a `startpa` parser and followed by a `endpa` parser
```


## the `seq` parser and its quantifiers

`seq` is special, it understands "quantifiers": `'?'`, `'+'` or `'*'`. They make behave `seq` a bit like a classical regex.

```
module CartParser include Raabro

  def fruit(i)
    rex(:fruit, i, /(tomato|apple|orange)/)
  end
  def vegetable(i)
    rex(:vegetable, i, /(potato|cabbage|carrot)/)
  end

  def cart(i)
    seq(:cart, i, :fruit, '*', :vegetable, '*')
  end
    # zero or more fruits followed by zero or more vegetables
end
```

(Yes, this sample parser parses string like "appletomatocabbage", it's not very useful, but I hope you get the point about `.seq`)


## LICENSE

MIT, see [LICENSE.txt](LICENSE.txt)

