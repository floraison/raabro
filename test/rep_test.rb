
#
# specifying raabro
#
# Sun Sep 20 09:36:16 JST 2015
#

group Raabro do

  group '.rep' do

    test 'returns a tree with result == 0 in case of failure' do

      i = Raabro::Input.new('toto')

      t = Raabro.rep(:x, i, :to, 3, 4)

      assert(
        t.to_a(:leaves => true),
        [ :x, 0, 0, 0, nil, :rep, [
          [ nil, 1, 0, 2, nil, :str, 'to' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ],
          [ nil, 0, 4, 0, nil, :str, [] ]
        ] ])

      assert i.offset, 0
    end

    test 'prunes' do

      i = Raabro::Input.new('toto', :prune => true)

      t = Raabro.rep(:x, i, :to, 3, 4)

      assert(
        t.to_a(:leaves => true),
        [ :x, 0, 0, 0, nil, :rep, [
          [ nil, 1, 0, 2, nil, :str, 'to' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ]
        ] ])

      assert i.offset, 0
    end

    test "fails (min not reached)" do

      i = Raabro::Input.new('toto')

      t = Raabro.rep(:x, i, :to, 3)

      assert(
        t.to_a(:leaves => true),
        [ :x, 0, 0, 0, nil, :rep, [
          [ nil, 1, 0, 2, nil, :str, 'to' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ],
          [ nil, 0, 4, 0, nil, :str, [] ]
        ] ])

      assert i.offset, 0
    end

    test "succeeds (max set)" do

      i = Raabro::Input.new('tototo')

      t = Raabro.rep(:x, i, :to, 1, 2)

      assert(
        t.to_a(:leaves => true),
        [ :x, 1, 0, 4, nil, :rep, [
          [ nil, 1, 0, 2, nil, :str, 'to' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ]
        ] ])

      assert i.offset, 4
    end

    test "succeeds (max not set)" do

      i = Raabro::Input.new('toto')

      t = Raabro.rep(:x, i, :to, 1)

      assert(
        t.to_a(:leaves => true),
        [ :x, 1, 0, 4, nil, :rep, [
          [ nil, 1, 0, 2, nil, :str, 'to' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ],
          [ nil, 0, 4, 0, nil, :str, [] ]
        ] ])

      assert i.offset, 4
    end
  end
end

