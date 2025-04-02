
#
# specifying raabro
#
# Sun Sep 20 06:11:54 JST 2015
#

group Raabro do

  group '.str' do

    test 'returns a tree with result == 0 in case of failure' do

      i = Raabro::Input.new('toto')

      t = Raabro.str(nil, i, 'nada')

      assert t.to_a, [ nil, 0, 0, 0, nil, :str, [] ]
      assert i.offset, 0
    end

    test "returns a tree with result == 1 in case of success" do

      i = Raabro::Input.new('toto')

      t = Raabro.str(nil, i, 'toto')

      assert t.to_a, [ nil, 1, 0, 4, nil, :str, [] ]
      assert i.offset, 4
    end

    test "names the result if there is a name" do

      i = Raabro::Input.new('toto')

      t = Raabro.str(:x, i, 'toto')

      assert t.to_a, [ :x, 1, 0, 4, nil, :str, [] ]
      assert i.offset, 4
    end

    test "names in case of failure as well" do

      i = Raabro::Input.new('toto')

      t = Raabro.str(:y, i, 'nada')

      assert t.to_a, [ :y, 0, 0, 0, nil, :str, [] ]
      assert i.offset, 0
    end

    test "accepts an empty input" do

      i = Raabro::Input.new('toto')
      i.offset = 4

      t = Raabro.str(nil, i, 'nada')

      assert t.to_a, [ nil, 0, 4, 0, nil, :str, [] ]
      assert i.offset, 4
    end
  end
end

