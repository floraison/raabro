
#
# specifying raabro
#
# Sun Sep 20 07:12:35 JST 2015
#

group Raabro do

  group '.rex' do

    test 'hits' do

      i = Raabro::Input.new('toto')

      t = Raabro.rex(nil, i, /t[ua]/)

      assert t.to_a, [ nil, 0, 0, 0, nil, :rex, [] ]
      assert i.offset, 0
    end

    test 'misses' do

      i = Raabro::Input.new('toto')

      t = Raabro.rex(nil, i, /(to)+/)

      assert t.to_a(:leaves => true), [ nil, 1, 0, 4, nil, :rex, 'toto' ]
      assert i.offset, 4
    end

    test 'misses if the match is not at the current input offset' do

      i = Raabro::Input.new('tato')

      t = Raabro.rex(:biga, i, /(to)+/)

      assert t.to_a(:leaves => true), [ :biga, 0, 0, 0, nil, :rex, [] ]
      assert i.offset, 0
    end
  end
end

