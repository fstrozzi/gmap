
# Author:: Francesco Strozzi
# Email:: francesco.strozzi@gmail.com
# Copyright:: 2008 Francesco Strozzi   
# License:: The Ruby License



module Gmap

  # This module allows the parsing of the standard output of Gmap (http://www.gene.com/share/gmap/)
  # 
  # Example: 
  # 
  #   Gmap::Core.open("output.gmap") do |gmap|
  #   
  #     gmap.each_sequence do |seq|
  #     
  #       seq.each do |result|
  #      
  #         result.query (Query sequence name)
  #         result.target  (Target sequence name)
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
  #         ONLY IF GENE MAPS ARE USED WITH GMAP
  #
  #         result.gene_start (Start coordinate of the overlapping gene)
  #         result.gene_end (End coordinate of the overlapping gene)
  #         result.gene_id (ID of the overlapping gene)
  #       end
  #   
  #     end
  #   
  #   end
  #

  class Core

    attr_reader :io
    def initialize(io)
      @io = io
    end

    # Open the gmap file for reading

    def self.open(file)

      f = File.open(file)
      if block_given?
        yield Gmap::Core.new(f)
        f.close
      else
        Gmap::Core.new(f)
      end
    end

    # Close the IO stream on the Gmap file

    def close
      @io.close
    end

    # Iterates on every sequence processed by Gmap and returns an array of Gmap::Result objects
    # each of them corresponding to a Path (result) for that sequence 


    def each_sequence
      start = false
      res = Gmap::Result.new
      all_results = []
      query = nil
      @io.each_line do |l| 
         if l=~/>(\d+|\w+)\s/ and !start then 
           start = true
           query = "#{$1}"                          
         elsif l=~/>(\d+|\w+)\s/ and start then
           res.query = query
           all_results << res.dup if res.target != nil
           query = "#{$1}"
           if block_given?
             yield all_results
           else
             raise ArgumentError, "Block needed"
           end 
           all_results.clear
           res.clear      
         elsif l=~/Path\s\d+/ and res.target != nil then
           res.query = query
           all_results << res.dup
           res.clear
         end    
         res = parse_line(res,l)
      end
      if start then
        res.query = query
        all_results << res.dup if res.target != nil
        if block_given?
          yield all_results
        else
          raise ArgumentError, "Block needed"
        end
      end
    end

    private

    # The method is called internally from the Gmap#each_result method, 
    # to parse the lines in the output of Gmap and save the information into a Gmap::Result object        

    def parse_line(res,l)
      l.chomp!
      if res.search_aln then
        res = get_aln(res,l)
      else 	
        case l
        when /Path \d+:\s+query\s+(\d+)--(\d+)\s+\(\d+ bp\)\s+=>/
          res.q_start = "#{$1}".to_i
          res.q_end = "#{$2}".to_i
        when /Genomic pos:.*\((.*)\sstrand\)/	
          if "#{$1}"=~/\+/ then
            res.strand = 1
          else 
            res.strand = -1
          end
        when /Accessions:\s+(.*):(.*)--(.*)\s+\(out of.*/
            res.target = "#{$1}"
            t_start = "#{$2}"
            t_end = "#{$3}"
            t_start.gsub!(/,/,'')
            t_end.gsub!(/,/,'')
            res.start = t_start.to_i
            res.end = t_end.to_i
        when /Number of exons: (\d+)/
          if res.exons.nil?
            res.exons = "#{$1}".to_i
          end	
        when /Trimmed coverage:\s(.*)\s\(trimmed length/
          res.coverage = "#$1".to_f if res.coverage.nil?
        when /Percent identity:\s(.*)\s\(\d+ matches, (\d+) mismatches, (\d+) indels,/
          if res.perc_identity.nil?	
            res.perc_identity = "#{$1}".to_f
            res.mismatch = "#{$2}".to_i
            res.indels = "#{$3}".to_i
          end	
        when /Amino acid changes: (.*)/	
          aa = "#{$1}"
          res.aa_change = aa if aa.to_s=~/\w+/
        when /Alignment for path \d+:/
          res.set_search
        when /.*gene_maps\s+\S+:(\d+)..(\d+)\s+(\d+)/	
            res.gene_start = "#{$1}".to_i
            res.gene_end = "#{$2}".to_i
            res.gene_id = "#{$3}".to_i	
        end
      end  
      res
    end

    # The method is called from 'parse_line' to save the sequence alignment information from the gmap output 

    def get_aln(res,l)
      
      if l =~/.*:\d+\s[A|T|C|G].+.*/ then
        res.aln << l+"\n"
        res.set_save      
      end

      if res.c >= 1 and res.c < 3 then
        res.aln << l+"\n"
      end
      res.aln << l+"\n" if l=~/aa.g/
      res.aln << l+"\n" if l=~/aa.c/
      if res.c == 3 then
        res.aln.chomp!
        res.set_search
        res.set_save
      end
      if res.search_aln and res.save_aln then
        res.count
      end
      res
    end


  end

  # This class store the informations of a single Gmap result

  class Result 

  	attr_accessor :query, :target, :q_start, :q_end, :start, :end, :strand ,:exons, :coverage, :perc_identity, :indels, :mismatch, :aa_change, :gene_start, :gene_end, :gene_id, :aln
    attr_reader :search_aln, :c, :save_aln
    
    def initialize
        clear
    end
    # Initializes all the attributes of the result
  	def clear
  		@query = nil
  		@target = nil
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
  		@q_start = nil
  		@q_end = nil 
  		@aln = ""
  		
  	# Inizalize control attributes
  		  		 		
  		@maps = false
  		@search_aln = false
  		@save_aln = false
  		@c = 0
  	end
  	
  	def set_search
  	  if @search_aln then
  	    @search_aln = false
  	  else
  	    @search_aln = true
  	  end  
	  end
	  
	  
  	def set_save
  	  if @save_aln then
  	    @save_aln = false
  	  else
  	    @save_aln = true
  	  end  
	  end
	  
	  def count
      @c += 1
    end

  protected

    attr_writer :search_aln, :c, :path, :maps

  end


end





