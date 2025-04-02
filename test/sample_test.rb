
#
# specifying raabro
#
# Sun Oct 11 04:24:32 SGT 2015
#

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


group Raabro do

  group Sample::OwnRewrite do

    test 'uses its own rewrite' do

      assert(
        Sample::OwnRewrite.parse('hello'),
        [ :ok, 'hello' ])
    end
  end
end

