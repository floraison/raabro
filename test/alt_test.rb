
#
# specifying raabro
#
# Sun Sep 20 07:31:53 JST 2015
#


group Raabro do

  group '.alt' do

    test "returns a tree with result == 0 in case of failure" do

      i = Raabro::Input.new('tutu')

      t = Raabro.alt(nil, i, :ta, :to)

      assert(
        t.to_a(:leaves => true),
        [ nil, 0, 0, 0, nil, :alt, [
          [ nil, 0, 0, 0, nil, :str, [] ],
          [ nil, 0, 0, 0, nil, :str, [] ]
        ] ])

      assert i.offset, 0
    end

    test "succeeds (1st alternative)" do

      i = Raabro::Input.new('tato')

      t = Raabro.alt(nil, i, :ta, :to)

      assert(
        t.to_a(:leaves => true),
        [ nil, 1, 0, 2, nil, :alt, [
          [ nil, 1, 0, 2, nil, :str, 'ta' ]
        ] ])

      assert i.offset, 2
    end

    test "succeeds (2nd alternative)" do

      i = Raabro::Input.new('tato')

      t = Raabro.alt(nil, i, :to, :ta)

      assert(
        t.to_a(:leaves => true),
        [ nil, 1, 0, 2, nil, :alt, [
          [ nil, 0, 0, 0, nil, :str, [] ],
          [ nil, 1, 0, 2, nil, :str, 'ta' ]
        ] ])

      assert i.offset, 2
    end

    test 'prunes' do

      i = Raabro::Input.new('tato', :prune => true)

      t = Raabro.alt(nil, i, :to, :ta)

      assert(
        t.to_a(:leaves => true),
        [ nil, 1, 0, 2, nil, :alt, [
          [ nil, 1, 0, 2, nil, :str, 'ta' ]
        ] ])

      assert i.offset, 2
    end

    group 'when not greedy (default)' do

      test 'goes with the first successful result' do

        i = Raabro::Input.new('xx')

        t = Raabro.alt(nil, i, :onex, :twox)

        assert(
          t.to_a(:leaves => true),
          [ nil, 1, 0, 1, nil, :alt, [
            [ :onex, 1, 0, 1, nil, :str, 'x' ]
          ] ])

        assert i.offset, 1
      end
    end

    group 'when greedy (last argument set to true)' do

      test 'takes the longest successful result' do

        i = Raabro::Input.new('xx')

        t = Raabro.alt(nil, i, :onex, :twox, true)

        assert(
          t.to_a(:leaves => true),
          [ nil, 1, 0, 2, nil, :altg, [
            [ :onex, 0, 0, 1, nil, :str, [] ],
            [ :twox, 1, 0, 2, nil, :str, 'xx' ]
          ] ])

        assert i.offset, 2
      end
    end
  end

  group '.altg' do

    test 'is greedy, always' do

      i = Raabro::Input.new('xx')

      t = Raabro.altg(nil, i, :onex, :twox)

      assert(
        t.to_a(:leaves => true),
        [ nil, 1, 0, 2, nil, :altg, [
          [ :onex, 0, 0, 1, nil, :str, [] ],
          [ :twox, 1, 0, 2, nil, :str, 'xx' ]
        ] ])

      assert i.offset, 2
    end

    test 'prunes' do

      i = Raabro::Input.new('xx', :prune => true)

      t = Raabro.altg(nil, i, :onex, :twox)

      assert(
        t.to_a(:leaves => true),
        [ nil, 1, 0, 2, nil, :altg, [
          [ :twox, 1, 0, 2, nil, :str, 'xx' ]
        ] ])

      assert i.offset, 2
    end

    test 'declares a single winner' do

      i = Raabro::Input.new('xx', :prune => true)

      t = Raabro.altg(nil, i, :twox, :onex)

      assert(
        t.to_a(:leaves => true),
        [ nil, 1, 0, 2, nil, :altg, [
          [ :twox, 1, 0, 2, nil, :str, 'xx' ]
        ] ])

      assert i.offset, 2
    end

    test 'takes the longest and latest winner' do

      i = Raabro::Input.new('xx', :prune => true)

      t = Raabro.altg(nil, i, :twox, :onex, :deux)

      assert(
        t.to_a(:leaves => true),
        [ nil, 1, 0, 2, nil, :altg, [
          [ :deux, 1, 0, 2, nil, :str, 'xx' ]
        ] ])

      assert i.offset, 2
    end
  end
end

