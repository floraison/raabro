
#
# specifying raabro
#
# Wed Apr  2 13:39:51 JST 2025
#

group Raabro do

  group '.blk' do

    test 'hits' do

      i = Raabro::Input.new('toto')

      t = Raabro.blk(nil, i) { |s, i| s == 'toto' ? 4 : false }

      assert t.to_a, [ nil, 1, 0, 4, nil, :blk, [] ]
      assert i.offset, 4
    end

    test 'misses' do

      i = Raabro::Input.new('toto')

      t = Raabro.blk(nil, i) { |s, i| s == 'nada' ? 4 : false }

      assert t.to_a(:leaves => true), [ nil, 0, 0, 0, nil, :blk, [] ]
      assert i.offset, 0
    end
  end
end

