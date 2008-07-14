require 'test/unit'
require 'lib/gmap'

class GmapTest < Test::Unit::TestCase
  
  def setup
    @data = 'samples/test.gmap'
  end
  
  def test_open
    assert_nothing_raised do 
      g = Gmap::Core.open(@data)
      g.close
    end
  end
  
  
end