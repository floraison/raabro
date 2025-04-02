
#
# specifying raabro
#
# Mon Sep 21 06:55:35 JST 2015
#


group Raabro do

  group '.jseq' do

    test 'parses elts joined by a separator' do

      i = Raabro::Input.new('a,b,c')

      t = Raabro.jseq(:j, i, :cha, :com)

      assert(
        t.to_a(:leaves => true),
        [ :j, 1, 0, 5, nil, :jseq, [
          [ nil, 1, 0, 1, nil, :rex, 'a' ],
          [ nil, 1, 1, 1, nil, :str, ',' ],
          [ nil, 1, 2, 1, nil, :rex, 'b' ],
          [ nil, 1, 3, 1, nil, :str, ',' ],
          [ nil, 1, 4, 1, nil, :rex, 'c' ],
          [ nil, 0, 5, 0, nil, :str, [] ]
        ] ])

      assert i.offset, 5
    end

    test 'prunes' do

      i = Raabro::Input.new('a,b,c', :prune => true)

      t = Raabro.jseq(:j, i, :cha, :com)

      assert(
        t.to_a(:leaves => true),
        [ :j, 1, 0, 5, nil, :jseq, [
          [ nil, 1, 0, 1, nil, :rex, 'a' ],
          [ nil, 1, 1, 1, nil, :str, ',' ],
          [ nil, 1, 2, 1, nil, :rex, 'b' ],
          [ nil, 1, 3, 1, nil, :str, ',' ],
          [ nil, 1, 4, 1, nil, :rex, 'c' ]
        ] ])

      assert i.offset, 5
    end

    test 'fails when 0 elements' do

      i = Raabro::Input.new('')

      t = Raabro.jseq(:j, i, :cha, :com)

      assert(
        t.to_a(:leaves => true),
        [ :j, 0, 0, 0, nil, :jseq, [
          [ nil, 0, 0, 0, nil, :rex, [] ]
        ] ])

      assert i.offset, 0
    end

    test 'does not include trailing separators' do

      i = Raabro::Input.new('a,b,', :prune => false)

      t = Raabro.jseq(:j, i, :cha, :com)

      assert(
        t.to_a(:leaves => true),
        [:j, 1, 0, 3, nil, :jseq, [
          [nil, 1, 0, 1, nil, :rex, 'a'],
          [nil, 1, 1, 1, nil, :str, ','],
          [nil, 1, 2, 1, nil, :rex, 'b'],
          [nil, 0, 3, 1, nil, :str, []],
          [nil, 0, 4, 0, nil, :rex, []]]])
    end
  end
end

