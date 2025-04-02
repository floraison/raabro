
#
# specifying raabro
#
# Sun Sep 20 06:11:54 JST 2015
#

group Raabro do

  group '.seq' do

    test "returns a tree with result == 0 in case of failure" do

      i = Raabro::Input.new('tato')

      t = Raabro.seq(nil, i, :to, :ta)

      assert(
        t.to_a,
        [ nil, 0, 0, 0, nil, :seq, [
          [ nil, 0, 0, 0, nil, :str, [] ]
        ] ])

      assert i.offset, 0
    end

    test "returns a tree with result == 0 in case of failure (at 2nd step)" do

      i = Raabro::Input.new('tato')

      t = Raabro.seq(nil, i, :ta, :ta)

      assert(
        t.to_a(:leaves => true),
        [ nil, 0, 0, 0, nil, :seq, [
          [ nil, 1, 0, 2, nil, :str, 'ta' ],
          [ nil, 0, 2, 0, nil, :str, [] ]
        ] ])

      assert i.offset, 0
    end

    test "returns a tree with result == 1 in case of success" do

      i = Raabro::Input.new('tato')

      t = Raabro.seq(nil, i, :ta, :to)

      assert(
        t.to_a(:leaves => true),
        [ nil, 1, 0, 4, nil, :seq, [
          [ nil, 1, 0, 2, nil, :str, 'ta' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ]
        ] ])

      assert i.offset, 4
    end

    test "names the result if there is a name" do

      i = Raabro::Input.new('tato')

      t = Raabro.seq(:x, i, :ta, :to)

      assert(
        t.to_a(:leaves => true),
        [ :x, 1, 0, 4, nil, :seq, [
          [ nil, 1, 0, 2, nil, :str, 'ta' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ]
        ] ])

      assert i.offset, 4
    end

    test "names in case of failure as well" do

      i = Raabro::Input.new('tato')

      t = Raabro.seq(:y, i, :ta, :ta)

      assert(
        t.to_a(:leaves => true),
        [ :y, 0, 0, 0, nil, :seq, [
          [ nil, 1, 0, 2, nil, :str, 'ta' ],
          [ nil, 0, 2, 0, nil, :str, [] ]
        ] ])

      assert i.offset, 0
    end

    test "fails when the input string ends" do

      i = Raabro::Input.new('to')

      t = Raabro.seq(:z, i, :to, :ta)

      assert(
        t.to_a(:leaves => true),
        [ :z, 0, 0, 0, nil, :seq, [
          [ nil, 1, 0, 2, nil, :str, 'to' ],
          [ nil, 0, 2, 0, nil, :str, [] ]
        ] ])

      assert i.offset, 0
    end

    test "accepts an empty input" do

      i = Raabro::Input.new('tato', 4)

      t = Raabro.seq(nil, i, :to, :ta)

      assert(
        t.to_a,
        [ nil, 0, 4, 0, nil, :seq, [
          [ nil, 0, 4, 0, nil, :str, [] ]
        ] ])

      assert i.offset, 4
    end

    test 'returns as soon as the job is done' do

      i = Raabro::Input.new('to' * 10_000)

      t, d = do_time { Raabro.seq(:twotoes, i, :to, :to) }

      assert(
        t.to_a(leaves: true),
        [ :twotoes, 1, 0, 4, nil, :seq, [
          [ nil, 1, 0, 2, nil, :str, 'to' ],
          [ nil, 1, 2, 2, nil, :str, 'to' ] ] ])

      assert d < 0.2 # seconds
    end
  end

  group 'seq and quantifiers' do

    group 'a lonely quantifier' do

      test 'raises an ArgumentError' do

        i = Raabro::Input.new('tato')

        assert_error(
          lambda { t = Raabro.seq(nil, i, '?') },
          ArgumentError, 'lone quantifier ?')
      end
    end

    group 'the question mark quantifier' do

      test 'lets optional elements appear in sequences (miss)' do

        i = Raabro::Input.new('tato')

        t = Raabro.seq(nil, i, :ta, :tu, '?', :to)

        assert(
          t.to_a(:leaves => true),
          [ nil, 1, 0, 4, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 0, 2, 0, nil, :str, [] ],
            [ nil, 1, 2, 2, nil, :str, 'to' ]
          ] ])

        assert i.offset, 4
      end

      test 'lets optional elements appear in sequences (hit)' do

        i = Raabro::Input.new('tatuto')

        t = Raabro.seq(nil, i, :ta, :tu, '?', :to)

        assert(
          t.to_a(:leaves => true),
          [ nil, 1, 0, 6, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 1, 2, 2, nil, :str, 'tu' ],
            [ nil, 1, 4, 2, nil, :str, 'to' ]
          ] ])

        assert i.offset, 6
      end

      test 'lets optional elements appear in sequences (fail)' do

        i = Raabro::Input.new('tatututo')

        t = Raabro.seq(nil, i, :ta, :tu, '?', :to)

        assert(
          t.to_a(:leaves => true),
          [ nil, 0, 0, 0, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 1, 2, 2, nil, :str, 'tu' ],
            [ nil, 0, 4, 0, nil, :str, [] ]
          ] ])

        assert i.offset, 0
      end
    end

    group 'the star quantifier' do

      test 'lets optional elements recur in sequences (hit zero)' do

        i = Raabro::Input.new('tato')

        t = Raabro.seq(nil, i, :ta, :tu, '*', :to)

        assert(
          t.to_a(:leaves => true),
          [ nil, 1, 0, 4, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 0, 2, 0, nil, :str, [] ],
            [ nil, 1, 2, 2, nil, :str, 'to' ]
          ] ])

        assert i.offset, 4
      end

      test 'lets optional elements recur in sequences (hit)' do

        i = Raabro::Input.new('tatututo')

        t = Raabro.seq(nil, i, :ta, :tu, '*', :to)

        assert(
          t.to_a(:leaves => true),
          [ nil, 1, 0, 8, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 1, 2, 2, nil, :str, 'tu' ],
            [ nil, 1, 4, 2, nil, :str, 'tu' ],
            [ nil, 0, 6, 0, nil, :str, [] ],
            [ nil, 1, 6, 2, nil, :str, 'to' ]
          ] ])

        assert i.offset, 8
      end

      test 'stops when there is no progress' do

        i = Raabro::Input.new('abc')

        t = Raabro.seq(nil, i, :to_star, '*');

        assert(
          t.to_a(:leaves => true),
          [ nil, 1, 0, 0, nil, :seq, [
            [ nil, 1, 0, 0, nil, :rep, [
              [ nil, 0, 0, 0, nil, :str, [] ]
            ] ]
          ] ])
      end
    end

    group 'the plus quantifier' do

      test 'lets elements recur in sequences (hit)' do

        i = Raabro::Input.new('tatututo')

        t = Raabro.seq(nil, i, :ta, :tu, '+', :to)

        assert(
          t.to_a(:leaves => true),
          [ nil, 1, 0, 8, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 1, 2, 2, nil, :str, 'tu' ],
            [ nil, 1, 4, 2, nil, :str, 'tu' ],
            [ nil, 0, 6, 0, nil, :str, [] ],
            [ nil, 1, 6, 2, nil, :str, 'to' ]
          ] ])

        assert i.offset, 8
      end

      test 'lets elements recur in sequences (fail)' do

        i = Raabro::Input.new('tato')

        t = Raabro.seq(nil, i, :ta, :tu, '+', :to)

        assert(
          t.to_a(:leaves => true),
          [ nil, 0, 0, 0, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 0, 2, 0, nil, :str, [] ]
          ] ])

        assert i.offset, 0
      end

      test 'stops when there is no progress' do

        i = Raabro::Input.new('abc')

        t = Raabro.seq(nil, i, :to_star, '+')

        assert(
          t.to_a(:leaves => true),
          [ nil, 1, 0, 0, nil, :seq, [
            [ nil, 1, 0, 0, nil, :rep, [
              [ nil, 0, 0, 0, nil, :str, [] ]
            ] ]
          ] ])
      end
    end

    group 'the exclamation mark' do

      test 'throws an error when lonely' do

        i = Raabro::Input.new('tato')

        assert_error(
          lambda { t = Raabro.seq(nil, i, '!') },
          ArgumentError, 'lone quantifier !')
      end

      test 'hits post' do

        i = Raabro::Input.new('tatu')

        t = Raabro.seq(nil, i, :ta, :ta, '!')

        assert(
          t.to_a(leaves: true),
          [ nil, 1, 0, 2, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 1, 2, 0, nil, :nott, [
              [ nil, 0, 2, 0, nil, :str, [] ] ] ] ] ])

        assert i.offset, 2
      end

      test 'misses post' do

        i = Raabro::Input.new('tata')

        t = Raabro.seq(nil, i, :ta, :ta, '!')

        assert(
          t.to_a(leaves: true),
          [ nil, 0, 0, 0, nil, :seq, [
            [ nil, 1, 0, 2, nil, :str, 'ta' ],
            [ nil, 0, 2, 0, nil, :nott, [
              [ nil, 1, 2, 2, nil, :str, 'ta' ] ] ] ] ])

        assert i.offset, 0
      end

      test 'hits pre' do

        i = Raabro::Input.new('tatu')

        t = Raabro.seq(nil, i, :tu, '!', :ta, :tu)

        assert(
          t.to_a(leaves: true),
          [ nil, 1, 0, 4, nil, :seq, [
            [ nil, 1, 0, 0, nil, :nott, [
              [ nil, 0, 0, 0, nil, :str, [] ] ] ],
              [ nil, 1, 0, 2, nil, :str, 'ta' ],
              [ nil, 1, 2, 2, nil, :str, 'tu' ] ] ])

        assert i.offset, 4
      end

      test 'misses pre' do

        i = Raabro::Input.new('tutu')

        t = Raabro.seq(nil, i, :tu, '!', :ta, :tu)

        assert(
          t.to_a(leaves: true),
          [ nil, 0, 0, 0, nil, :seq, [
            [ nil, 0, 0, 0, nil, :nott, [
              [ nil, 1, 0, 2, nil, :str, 'tu' ] ] ] ] ])

        assert i.offset, 0
      end
    end
  end
end

