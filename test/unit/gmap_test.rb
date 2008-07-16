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
        check_first(seq) if seq[0].query == 'FIRST'
        check_second(seq) if seq[0].query == 'SECOND'  
      end
    end
  end
  
  def check_first(seq)
    # first result
    assert_equal 'ENSBTAT00000028007',seq[0].target
    assert_equal 36.1, seq[0].coverage
    assert_equal 100.0, seq[0].perc_identity
    assert_equal 0, seq[0].mismatch
    assert_equal 0, seq[0].indels
    assert_equal 14, seq[0].q_start
    assert_equal 26, seq[0].q_end
    assert_equal -1, seq[0].strand
    assert_equal 11477, seq[0].start
    assert_equal 11489, seq[0].end
    assert_equal 1, seq[0].exons
    assert_equal nil, seq[0].aa_change
    assert_match(/CTTCGTATTGCTG/,seq[0].aln)
    # second result
    assert_equal 'ENSBTAT00000042528',seq[1].target
    assert_equal 100.0, seq[1].coverage
    assert_equal 97.2, seq[1].perc_identity
    assert_equal 1, seq[1].mismatch
    assert_equal 0, seq[1].indels
    assert_equal 1, seq[1].q_start
    assert_equal 36, seq[1].q_end
    assert_equal -1, seq[1].strand
    assert_equal 229, seq[1].start
    assert_equal 264, seq[1].end
    assert_equal 1, seq[1].exons
    assert_equal 'K10T [28]', seq[1].aa_change
    assert_match(/G  I  H  M  V  K  A  R  P  K  A/,seq[1].aln)
    assert_match(/GGGAATTCACATGGTTAAGGCTAGGCCTAAAGCTAT/,seq[1].aln)
    assert_match(/GGGAATTCACATGGTTAAGGCTAGGCCTACAGCTAT/,seq[1].aln)
    assert_match(/G  I  H  M  V  K  A  R  P  T  A/,seq[1].aln)
    # third result
    assert_equal 'ENSBTAT00000044819',seq[2].target
    assert_equal 38.9, seq[2].coverage
    assert_equal 100.0, seq[2].perc_identity
    assert_equal 0, seq[2].mismatch
    assert_equal 0, seq[2].indels
    assert_equal 18, seq[2].q_start
    assert_equal 31, seq[2].q_end
    assert_equal 1, seq[2].strand
    assert_equal 611, seq[2].start
    assert_equal 624, seq[2].end
    assert_equal 1, seq[2].exons
    assert_equal nil, seq[2].aa_change
    assert_match(/GAAATCTTGACTGA/,seq[2].aln)
  end
  
  def check_second(seq)
    # first result
    assert_equal 'chr17',seq[0].target
    assert_equal 41.7, seq[0].coverage
    assert_equal 100.0, seq[0].perc_identity
    assert_equal 0, seq[0].mismatch
    assert_equal 0, seq[0].indels
    assert_equal 12, seq[0].q_start
    assert_equal 26, seq[0].q_end
    assert_equal -1, seq[0].strand
    assert_equal 21154428, seq[0].start
    assert_equal 21154442, seq[0].end
    assert_equal 1, seq[0].exons
    assert_equal nil, seq[0].aa_change
    assert_match(/TTCGTATACCGTATT/,seq[0].aln)
    # second result
    assert_equal 'chr11',seq[1].target
    assert_equal 52.8, seq[1].coverage
    assert_equal 94.7, seq[1].perc_identity
    assert_equal 1, seq[1].mismatch
    assert_equal 0, seq[1].indels
    assert_equal 9, seq[1].q_start
    assert_equal 27, seq[1].q_end
    assert_equal 1, seq[1].strand
    assert_equal 99537167, seq[1].start
    assert_equal 99537185, seq[1].end
    assert_equal 1, seq[1].exons
    assert_equal nil, seq[1].aa_change
    assert_match(/AGGCATGCATGGCCCGAAC/,seq[1].aln)
    assert_match(/ACGCATGCATGGCCCGAAC/,seq[1].aln)
    # third result
    assert_equal 'chr22',seq[2].target
    assert_equal 100.0, seq[2].coverage
    assert_equal 100.0, seq[2].perc_identity
    assert_equal 0, seq[2].mismatch
    assert_equal 0, seq[2].indels
    assert_equal 1, seq[2].q_start
    assert_equal 36, seq[2].q_end
    assert_equal -1, seq[2].strand
    assert_equal 57923909, seq[2].start
    assert_equal 57926444, seq[2].end
    assert_equal 2, seq[2].exons
    assert_equal nil, seq[2].aa_change
    assert_match(/R  A  P  R  R  A  G           E  G  R  G  \*/,seq[2].aln)
    assert_match(/CGCGCACCTCGGCGTGCAGGTG\.\.\.CAGGTGAAGGGAGAGGATGA/,seq[2].aln)
    assert_match(/CGCGCACCTCGGCGTGCAG  2500   GTGAAGGGAGAGGATGA/,seq[2].aln)
    assert_equal 57912718,seq[2].gene_start
    assert_equal 57926714,seq[2].gene_end
    assert_equal 507939,seq[2].gene_id
  end
  
end