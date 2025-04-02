
#
# specifying raabro
#
# Tue Sep 22 07:55:52 JST 2015
#

group Raabro::Tree do

  group '.lookup' do

    test 'returns the first node with the given name' do

      t = Sample::Cal.parse('4 5 6 + 1 2 3 * +', rewrite: false)

      assert(
        t.lookup('item').to_a(:leaves),
        [ :item, 1, 0, 1, nil, :alt, [
          [ :num, 1, 0, 1, nil, :rex, '4' ] ] ])
    end

    test 'returns the first named node if the given name is nil' do

      t = Sample::Cal.parse('4 5 6 + 1 2 3 * +', rewrite: false)

      assert(
        t.lookup.to_a(:leaves),
        [ :item, 1, 0, 1, nil, :alt, [
          [ :num, 1, 0, 1, nil, :rex, '4' ] ] ])
    end
  end

  group '.sublookup' do

    test 'skips the callee node' do

      t = Sample::Cal.parse('4 5 6 + 1 2 3 * +', rewrite: false)
      t = t.children[0]

      assert(
        t.sublookup.to_a(:leaves),
        [ :num, 1, 0, 1, nil, :rex, '4' ])
    end
  end

  group '.gather' do

    test 'returns all the nodes with a given name' do

      t = Sample::Cal.parse('4 5 6 + 1 2 3 * +', rewrite: false)

      assert(
        t.gather('op').collect { |n| n.to_a(:leaves) },
        [ [ :op, 1, 6, 1, nil, :rex, '+' ],
          [ :op, 1, 14, 1, nil, :rex, '*' ],
          [ :op, 1, 16, 1, nil, :rex, '+' ] ])
    end

    test 'returns all the nodes with a name if the given name is nil' do

      t = Sample::Cal.parse('4 5 6 + 1 2 3 * +', rewrite: false)

      assert(
        t.gather.collect { |n| n.to_a(:leaves) },
        [
          [ :item, 1, 0, 1, nil, :alt, [
            [ :num, 1, 0, 1, nil, :rex, '4' ] ] ],
          [ :item, 1, 2, 1, nil, :alt, [
            [ :num, 1, 2, 1, nil, :rex, '5' ] ] ],
          [ :item, 1, 4, 1, nil, :alt, [
            [ :num, 1, 4, 1, nil, :rex, '6' ] ] ],
          [ :item, 1, 6, 1, nil, :alt, [
            [ :op, 1, 6, 1, nil, :rex, '+' ] ] ],
          [ :item, 1, 8, 1, nil, :alt, [
            [ :num, 1, 8, 1, nil, :rex, '1' ] ] ],
          [ :item, 1, 10, 1, nil, :alt, [
            [ :num, 1, 10, 1, nil, :rex, '2' ] ] ],
          [ :item, 1, 12, 1, nil, :alt, [
            [ :num, 1, 12, 1, nil, :rex, '3' ] ] ],
          [ :item, 1, 14, 1, nil, :alt, [
            [ :op, 1, 14, 1, nil, :rex, '*' ] ] ],
          [ :item, 1, 16, 1, nil, :alt, [
            [ :op, 1, 16, 1, nil, :rex, '+' ] ] ]
        ])
    end
  end

  group '.subgather' do

    test 'skips the callee node' do

      t = Sample::Cal.parse('4 5 6 + 1 2 3 * +', rewrite: false)

      assert(
        t.children[0].subgather.collect { |n| n.to_a(:leaves) },
        [ [ :num, 1, 0, 1, nil, :rex, '4' ] ])
    end
  end

  group '.string' do

    test 'returns the string covered by the tree' do

      t = Sample::Arith.parse('11 + 12', rewrite: false)

#Raabro.pp(t, colours: true)
      assert t.string, '11 + 12'
      assert t.sublookup(:number).string, '11 '
      assert t.sublookup(:plus).string, '+ '
    end
  end

  group '.strinp' do

    test 'returns the string covered by the tree by stripped' do

      t = Sample::Arith.parse('11 + 13', rewrite: false)

#Raabro.pp(t, colours: true)
      assert t.strinp, '11 + 13'
      assert t.sublookup(:number).strinp, '11'
      assert t.sublookup(:plus).strinp, '+'
    end
  end

  group '.strim' do

    test 'returns the string covered by the tree by stripped' do

      t = Sample::Arith.parse('11 + 13', rewrite: false)

#Raabro.pp(t, colours: true)
      assert t.strim, '11 + 13'
      assert t.sublookup(:number).strim, '11'
      assert t.sublookup(:plus).strim, '+'
    end
  end

  group '.strind' do

    test 'returns the string covered by the tree downcased' do

      i = Raabro::Input.new('Hello')
      t = chas(i)

      assert t.strind, 'hello'
    end
  end

  group '.strinpd' do

    test 'returns the string covered by the tree stripped and downcased' do

      i = Raabro::Input.new('AloaH ')
      t = chas(i)

      assert t.strinpd, 'aloah'
    end
  end

  group '.symbol' do

    test 'returns the string covered by the tree as a symbol' do

      i = Raabro::Input.new('Hello ')
      t = chas(i)

      assert t.symbol, :Hello
    end
  end

  group '.symbod' do

    test 'returns the string covered by the tree as a downcased symbol' do

      i = Raabro::Input.new('Hello ')
      t = chas(i)

      assert t.symbod, :hello
    end
  end
end

