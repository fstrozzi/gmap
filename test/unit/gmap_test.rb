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
        assert_equal 'Array',seq.class.to_s
        assert_equal 'ENSBTAT00000028007',seq[0].target
        assert_equal 36.1, seq[0].coverage
        assert_equal 100.0, seq[0].perc_identity
        assert_equal 0, seq[0].mismatch
        assert_equal 0, seq[0].indels
        assert_equal 14, seq[0].q_start
        assert_equal 26, seq[0].q_end
        assert_equal 11477, seq[0].start
        assert_equal 11489, seq[0].end
        assert_equal 1, seq[0].exons
        assert_match(/CTTCGTATTGCTG/,seq[0].aln)
        break
      end
    end
  end
  
end