
#
# Specifying raabro
#
# Sat Sep 19 21:12:35 JST 2015
#

require 'pp'

require 'raabro'

#
# parsers

def ta(i); Raabro.str(nil, i, 'ta'); end
def to(i); Raabro.str(nil, i, 'to'); end
def tu(i); Raabro.str(nil, i, 'tu'); end

def to_plus(input); Raabro.rep(:tos, input, :to, 1); end
def to_star(input); Raabro.rep(nil, input, :to, 0); end
def to_qmark(input); Raabro.rep(nil, input, :to, 0, 1); end

def nta(i); Raabro.str('the-ta', i, 'ta'); end

def cha(i); Raabro.rex(nil, i, /\A[a-z]/); end
def com(i); Raabro.str(nil, i, ','); end

def lt(i); Raabro.str(nil, i, '<'); end
def gt(i); Raabro.str(nil, i, '>'); end

def onex(i); Raabro.str(:onex, i, 'x'); end
def twox(i); Raabro.str(:twox, i, 'xx'); end
def deux(i); Raabro.str(:deux, i, 'xx'); end

# testing eseq...
def com_qmark(i); Raabro.rep(nil, i, :com, 0, 1); end
def val(i); Raabro.alt(nil, i, :cha, :arr); end
def val_qmark(i); Raabro.rep(nil, i, :val, 0, 1); end
def sbstart(i); Raabro.str(nil, i, '['); end
def sbend(i); Raabro.str(nil, i, ']'); end
def arr(i); Raabro.eseq(nil, i, :sbstart, :val_qmark, :com_qmark, :sbend); end


#
# test modules

module Sample; end

module Sample::Cal include Raabro

  def sp(i); rex(nil, i, /\s+/); end

  def num(i); rex(:num, i, /-?[0-9]+/); end
  def op(i); rex(:op, i, /[+\-*\/]/); end
  def item(i); alt(:item, i, :num, :op); end

  def suite(i); jseq(nil, i, :item, :sp); end
end

module Sample::Arith include Raabro

  def number(i); rex(:number, i, /-?[0-9]+\s*/); end
  def plus(i); rex(:plus, i, /\+\s*/); end
  def minus(i); rex(:minus, i, /-\s*/); end

  def addition(i); seq(:addition, i, :number, :plus, :op_or_num); end
  def substraction(i); seq(:substraction, i, :number, :minus, :op_or_num); end

  def op_or_num(i); alt(nil, i, :addition, :substraction, :number); end
end

