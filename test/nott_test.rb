
#
# specifying raabro
#
# Sun May 10 13:45:35 JST 2020
#

group Raabro do

  group '.nott' do

    test 'hits' do

      i = Raabro::Input.new('to')
      t = Raabro.nott(:no0, i, :ta)

      assert(
        t.to_a(leaves: true),
        [ :no0, 1, 0, 0, nil, :nott, [
          [ nil, 0, 0, 0, nil, :str, [] ] ] ])

      assert i.offset, 0
    end

    test 'misses' do

      i = Raabro::Input.new('ta')
      t = Raabro.nott(:no0, i, :ta)

      assert(
        t.to_a(leaves: true),
        [ :no0, 0, 0, 0, nil, :nott, [
          [ nil, 1, 0, 2, nil, :str, 'ta' ] ] ])

      assert i.offset, 0
    end
  end
end

