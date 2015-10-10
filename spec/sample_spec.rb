
#
# specifying raabro
#
# Sun Oct 11 04:24:32 SGT 2015
#

require 'spec_helper'


module Sample::OwnRewrite include Raabro

  # parse

  def hello(i); str(:hello, i, 'hello'); end

  #alias root exp
    # not necessary since Raabro takes the last defined parser as the root

  # rewrite

  def rewrite(t)

    [ :ok, t.string ]
  end
end


describe Raabro do

  describe Sample::OwnRewrite do

    it 'uses its own rewrite' do

      expect(
        Sample::OwnRewrite.parse('hello')
      ).to eq(
        [ :ok, 'hello' ]
      )
    end
  end
end

