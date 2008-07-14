
# Author:: Francesco Strozzi, francesco.strozzi@gmail.com
# Copyright:: 2008 Francesco Strozzi   
# License:: The Ruby License
# 
# This class allows the parsing of the standard output of Gmap (http://www.gene.com/share/gmap/)
# 
# Example: 
# 
#   Gmap.open("output.gmap") do |gmap|
#   
#     gmap.each_sequence do |seq|
#     
#       seq.each do |result|
#      
#         result.name (Sequence Name)
#         result.chr  (Chromosomo name)
#         result.q_start (Start coordinate of the query sequence) 
#         result.q_end (End coordinate of the query sequence)
#         result.start (Start coordintate of the target sequence)
#         result.end (End coordinate of the target sequence) 
#         result.strand (Strand of the target sequence) 
#         result.exons (# exons found) 
#         result.coverage (Coverage of the query sequence) 
#         result.perc_identity (Pecentage of identity from the alignment)
#         result.indels (# insertion or deletions) 
#         result.mismatch (# mismatch)  
#         result.aa_change (Prediction of AA changes from mismatches and indels found) 
#         result.aln (Raw alignment between target and query sequences)
#     
#       end
#   
#     end
#   
#   end
# 



class Gmap
	
	attr_reader :io
  	def initialize(io)
		@io = io
	end

  # Open the gmap file for reading
        
	def self.open(file)

      f = File.open(file)
      if block_given?
         yield self.new(f)
         f.close
      else
         self.new(f)
      end                                 
		
		end
	end
        
  # Close the IO stream on the gmap file
        
  def close
      @io.close
  end

  # Iterates on every sequence processed by Gmap and returns an array of Gmap::Result objects
  # each of them corresponding to a Path (result) for that sequence 

        
	def each_sequence
		start = false
		res = Gmap::Result.new
    all_results = []
		@io.each_line do |l|
			if l=~/>>>.*/ 
                            
			elsif l=~/>\S+/ and !start then 
            start = true	                          
      elsif l=~/>\S+/ and start then
            if block_given?
				       yield all_results
            else
               all_results
            end 
            all_results.clear
			      res.clear      
			end
      if l=~/Path\s\d+/ and res.chr != nil then
         all_results << res
      end  
      res = parse_line(res,l)
		  end
		  if start then
         all_results << res if res.chr != nil
         if block_given?
            yield all_results
         else
            all_results
         end
		  end
	end

private

    # The method is called internally from the Gmap#each_result method, 
    # to parse the lines in the output of Gmap and save the information into a Gmap::Result object        

	def parse_line(res,l)
		l.chomp!
		if res.search_aln == true then
			res = get_aln(res,l)
		else 	
			case l
			    when />(\S+)\s/
					res.name = "#$1"
				when /Path 1:\s+query\s+(\d+)--(\d+)\s+\(\d+ bp\)\s+=>/
				  res.path = true
					res.q_start = "#$1"
					res.q_end = "#$2"
				when /Path 2: query/
					res.path = false
				when /Genomic pos:.*\((.*)\sstrand\)/
				  if res.strand.nil?	
					  if "#$1"=~/\+/ then
						  res.strand = '1'
					  else 
						  res.strand = '-1'
					  end
				  end
				when /Accessions:\s+(.*):(.*)--(.*)\s+\(out of.*/
					if res.path then
						res.chr = "#$1"
						res.start = "#$2"
						res.end = "#$3"
						res.start.gsub!(/,/,'')
						res.end.gsub!(/,/,'')
					end
				when /Number of exons: (\d+)/
				     if res.exons.nil?
					     res.exons = "#$1"
				     end	
				when /Trimmed coverage:\s(.*)\s\(trimmed length/
					res.coverage = "#$1" if res.coverage.nil?
				when /Percent identity:\s(.*)\s\(\d+ matches, (\d+) mismatches, (\d+) indels,/
				  if res.perc_identity.nil?	
					  res.perc_identity = "#$1"
					  res.mismatch = "#$2"
					  res.indels = "#$3"
				  end	
				when /Amino acid changes: (.*)/	
					res.aa_change = "#$1" if res.path == true
					res.path = false
				when /  Alignment for path 1:/
					res.search_aln = true
				when /\s+Map hits for path 1\s+\(1\):/
					res.maps = true
				when /.*gene_maps\s+\S+:(\d+)..(\d+)\s+(\d+)/	
				     if res.maps then	
					     res.gene_start = "#$1"
					     res.gene_end = "#$2"
					     res.gene_id = "#$3"
					     res.maps = false
				     end	
			end
			
		end
		res
	end
        
  # The method is called from 'parse_line', to save the sequence alignment information from the gmap output 
        
	def get_aln(res,l)

		if l =~/.*\w+.*:\d+\s[A|T|C|G].+/ then
			res.aln << l+"\n"
			res.save_aln = true
		end

		if res.c >= 1 and res.c < 3 then
			res.aln << l+"\n"
		end

		if res.c == 3 then
			res.aln.chomp!
			res.search_aln = false
			res.save_aln = false
		end
		if res.save_aln == true then
			res.c += 1
		end
		res
	end


end




