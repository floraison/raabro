
#
# specifying raabro
#
# Mon Sep 21 05:56:18 JST 2015
#

group Raabro do

  group '.all' do

    test 'fails when not all the input is consumed' do

      i = Raabro::Input.new('tototota')

      t = Raabro.all(nil, i, :to_plus)

      assert(
        t.to_a(:leaves => true),
        [ nil, 0, 0, 0, nil, :all, [
          [ :tos, 1, 0, 6, nil, :rep, [
            [ nil, 1, 0, 2, nil, :str, 'to' ],
            [ nil, 1, 2, 2, nil, :str, 'to' ],
            [ nil, 1, 4, 2, nil, :str, 'to' ],
            [ nil, 0, 6, 0, nil, :str, [] ]
          ] ]
        ] ])

      assert i.offset, 0
    end

    test 'succeeds when all the input is consumed' do

      i = Raabro::Input.new('tototo')

      t = Raabro.all(nil, i, :to_plus)

      assert(
        t.to_a(:leaves => true),
        [ nil, 1, 0, 6, nil, :all, [
          [ :tos, 1, 0, 6, nil, :rep, [
            [ nil, 1, 0, 2, nil, :str, 'to' ],
            [ nil, 1, 2, 2, nil, :str, 'to' ],
            [ nil, 1, 4, 2, nil, :str, 'to' ],
            [ nil, 0, 6, 0, nil, :str, [] ]
          ] ]
        ] ])

      assert i.offset, 6
    end
  end
end

