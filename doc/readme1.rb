
require 'raabro'


module PathParser include Raabro

  # piece parsers bottom to top

  def dot(i); str(nil, i, '.'); end
  def bend(i); str(nil, i, ']'); end
  def bstart(i); str(nil, i, '['); end
  def dq(i); str(nil, i, '"'); end
  def sq(i); str(nil, i, "'"); end

  def name(i); rex(:name, i, /[a-z0-9_]+/i); end
  def off(i); rex(:off, i, /\d+/); end

  def dqname(i); seq(nil, i, :dq, :name, :dq); end
  def sqname(i); seq(nil, i, :sq, :name, :sq); end

  def bindex(i); alt(:index, i, :off, :dqname, :sqname); end
  def dindex(i); alt(:index, i, :off, :name); end

  def bracket_index(i); seq(nil, i, :bstart, :bindex, :bend); end
  def dot_index(i); seq(nil, i, :dot, :dindex); end

  def then_index(i); alt(nil, i, :dot_index, :bracket_index); end
  def start_index(i); alt(nil, i, :dindex, :bracket_index); end

  def path(i); seq(:path, i, :start_index, :then_index, '*'); end

  # rewrite parsed tree

  def rewrite_name(t); t.string; end
  def rewrite_off(t); t.string.to_i; end
  def rewrite_index(t); rewrite(t.sublookup); end
  def rewrite_path(t); t.subgather(:index).collect { |tt| rewrite(tt) }; end
end


p PathParser.parse('0.name')
  # => [ 0, 'name' ],
p PathParser.parse('name.0')
  # => [ 'name', 0 ],
p PathParser.parse('11[0]')
  # => [ 11, 0 ],
p PathParser.parse("name['first']")
  # => [ 'name', 'first' ],
p PathParser.parse('name["last"]')
  # => [ 'name', 'last' ],
p PathParser.parse('name[0]')
  # => [ 'name', 0 ],
p PathParser.parse('[0].name')
  # => [ 0, 'name' ],

