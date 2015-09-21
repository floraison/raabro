
#
# specifying raabro
#
# Mon Sep 21 16:58:01 JST 2015
#

require 'spec_helper'

module Sample
  module Xel include Raabro

    def funame(i); rex(:funame, i, /[A-Z][A-Z0-9]*/); end
  end
end


describe Raabro do

  describe Sample::Xel do

    describe '.funame' do

      it 'hits' do

        i = Raabro::Input.new('NADA')

        t = Sample::Xel.funame(i)

        expect(t.to_a(:leaves => true)).to eq(
          [ :funame, 1, 0, 4, nil, :rex, 'NADA' ]
        )
      end
    end
  end
end

