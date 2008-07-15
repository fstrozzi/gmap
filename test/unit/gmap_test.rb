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
  
  def test_result
    Gmap::Core.open(@data) do |g|
      g.each_sequence do |seq|
        assert_equal 3,seq.size
      end
    end
  end
  
  
end