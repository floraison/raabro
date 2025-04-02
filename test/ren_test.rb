
#
# specifying raabro
#
# Mon Sep 21 05:46:00 JST 2015
#

group Raabro do

  group '.ren' do

    test 'returns the tree coming from the wrapped parser' do

      i = Raabro::Input.new('ta')

      t = Raabro.ren('renamed', i, :nta)

      assert(
        t.to_a(:leaves => true),
        [ 'renamed', 1, 0, 2, nil, :str, 'ta' ])

      assert i.offset, 2
    end
  end

  group '.rename' do

    test 'is an alias to .ren' do

      i = Raabro::Input.new('ta')

      t = Raabro.rename('autre', i, :nta)

      assert(
        t.to_a(:leaves => true),
        [ 'autre', 1, 0, 2, nil, :str, 'ta' ])

      assert i.offset, 2
    end
  end
end

