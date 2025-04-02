
#
# specifying raabro
#
# Mon Sep 21 10:15:35 JST 2015
#


group Raabro do

  group '.eseq' do

    test 'parses successfully' do

      i = Raabro::Input.new('<a,b>')

      t = Raabro.eseq(:list, i, :lt, :cha, :com, :gt)

      assert(
        t.to_a(:leaves => true),
        [ :list, 1, 0, 5, nil, :eseq, [
          [ nil, 1, 0, 1, nil, :str, '<' ],
          [ nil, 1, 1, 1, nil, :rex, 'a' ],
          [ nil, 1, 2, 1, nil, :str, ',' ],
          [ nil, 1, 3, 1, nil, :rex, 'b' ],
          [ nil, 0, 4, 0, nil, :str, [] ],
          [ nil, 1, 4, 1, nil, :str, '>' ]
        ] ])

      assert i.offset, 5
    end

    test 'prunes' do

      i = Raabro::Input.new('<a,b>', :prune => true)

      t = Raabro.eseq(:list, i, :lt, :cha, :com, :gt)

      assert(
        t.to_a(:leaves => true),
        [ :list, 1, 0, 5, nil, :eseq, [
          [ nil, 1, 0, 1, nil, :str, '<' ],
          [ nil, 1, 1, 1, nil, :rex, 'a' ],
          [ nil, 1, 2, 1, nil, :str, ',' ],
          [ nil, 1, 3, 1, nil, :rex, 'b' ],
          [ nil, 1, 4, 1, nil, :str, '>' ]
        ] ])

      assert i.offset, 5
    end

    test 'parses <>' do

      i = Raabro::Input.new('<>', :prune => true)

      t = Raabro.eseq(:list, i, :lt, :cha, :com, :gt)

      assert(
        t.to_a(:leaves => true),
        [ :list, 1, 0, 2, nil, :eseq, [
          [ nil, 1, 0, 1, nil, :str, '<' ],
          [ nil, 1, 1, 1, nil, :str, '>' ]
        ] ])

      assert i.offset, 2
    end

    group 'no start parser' do

      test 'parses successfully' do

        i = Raabro::Input.new('a,b>', prune: false)

        t = Raabro.eseq(:list, i, nil, :cha, :com, :gt)

        assert(
          t.to_a(:leaves => true),
          [ :list, 1, 0, 4, nil, :eseq, [
            [ nil, 1, 0, 1, nil, :rex, 'a' ],
            [ nil, 1, 1, 1, nil, :str, ',' ],
            [ nil, 1, 2, 1, nil, :rex, 'b' ],
            [ nil, 0, 3, 0, nil, :str, [] ],
            [ nil, 1, 3, 1, nil, :str, '>' ]
          ] ])

        assert i.offset, 4
      end
    end

    group 'no end parser' do

      test 'parses successfully' do

        i = Raabro::Input.new('<a,b')

        t = Raabro.eseq(:list, i, :lt, :cha, :com, nil)

        assert(
          t.to_a(:leaves => true),
          [ :list, 1, 0, 4, nil, :eseq, [
            [ nil, 1, 0, 1, nil, :str, '<' ],
            [ nil, 1, 1, 1, nil, :rex, 'a' ],
            [ nil, 1, 2, 1, nil, :str, ',' ],
            [ nil, 1, 3, 1, nil, :rex, 'b' ],
            [ nil, 0, 4, 0, nil, :str, [] ]
          ] ])

        assert i.offset, 4
      end

      test 'prunes' do

        i = Raabro::Input.new('<a,b', :prune => true)

        t = Raabro.eseq(:list, i, :lt, :cha, :com, nil)

        assert(
          t.to_a(:leaves => true),
          [ :list, 1, 0, 4, nil, :eseq, [
            [ nil, 1, 0, 1, nil, :str, '<' ],
            [ nil, 1, 1, 1, nil, :rex, 'a' ],
            [ nil, 1, 2, 1, nil, :str, ',' ],
            [ nil, 1, 3, 1, nil, :rex, 'b' ]
          ] ])

        assert i.offset, 4
      end
    end

    group 'no progress' do

      test 'parses <>' do

        i = Raabro::Input.new('<>', :prune => true)

        t = arr(i)

        assert(
          t.to_a(:leaves => true),
          [ nil, 1, 0, 2, nil, :eseq, [
            [ nil, 1, 0, 1, nil, :str, '<' ],
            [ nil, 1, 1, 0, nil, :rex, '' ],
            [ nil, 1, 1, 1, nil, :str, '>' ]
          ] ])

        assert i.offset, 2
      end

      test 'parses <a,,a>' do

        i = Raabro::Input.new('<a,,a>', :prune => true)

        t = arr(i)

        assert(
          t.to_a(:leaves => true),
          [ nil, 1, 0, 6, nil, :eseq, [
            [ nil, 1, 0, 1, nil, :str, '<' ],
            [ nil, 1, 1, 1, nil, :rex, 'a' ],
            [ nil, 1, 2, 1, nil, :rex, ',' ],
            [ nil, 1, 3, 0, nil, :rex, '' ],
            [ nil, 1, 3, 1, nil, :rex, ',' ],
            [ nil, 1, 4, 1, nil, :rex, 'a' ],
            [ nil, 1, 5, 1, nil, :str, '>' ]
          ] ])

        assert i.offset, 6
      end
    end
  end
end

