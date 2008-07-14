# This class store the informations of a single Gmap result
      
class Result 

	attr_accessor :name, :chr, :q_start, :q_end, :start, :end, :strand ,:exons, :coverage, :perc_identity, :indels, :mismatch, :aa_change, :gene_start, :gene_end, :gene_id, :path, :maps, :aln, :search_aln, :c, :save_aln
	
        def initialize
          clear
        end
  # Initializes all the attributes of the result
	def clear
		@name = nil
		@chr = nil
		@start = nil
		@end = nil
		@strand = nil
		@exons = nil
		@coverage = nil
		@perc_identity = nil
		@indels = nil
		@mismatch = nil
		@aa_change = nil
		@gene_start = nil
		@gene_end = nil
		@gene_id = nil
		@path = nil
		@maps = nil
		@q_start = nil
		@q_end = nil
		@aln = ""
		@search_aln = false
		@c = 0
		@save_aln = false
	end

end