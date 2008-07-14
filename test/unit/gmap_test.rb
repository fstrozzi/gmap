require 'test/unit'
require '../../gmap'

class GmapTest < Test::Unit::TestCase
  
  def setup
    data = '../data/test.gmap'
  end
  
  def test_open
    assert_nothing_raised g = Gmap.open(data)
    assert_nothing_raised g.close
  end
  
  
end