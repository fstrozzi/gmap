
# Author:: Francesco Strozzi, francesco.strozzi@gmail.com
# Copyright:: 2008 Francesco Strozzi   
# License:: The Ruby License
# 


module Gmap

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

  class Core

    attr_reader :io
    def initialize(io)
      @io = io
    end

    # Open the gmap file for reading

    def self.open(file)

      f = File.open(file)
      #if block_given?
      #  yield Gmap::Core.new(f)
      #  f.close
      #else
        Gmap::Core.new(f)
      #end
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
          res = Gmap::Result.new
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
          res.set_path
          res.q_start = "#$1"
          res.q_end = "#$2"
        when /Path 2: query/
          res.set_path
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
          res.aa_change = "#$1" if res.path
          res.set_path
        when /  Alignment for path \d+:/
          res.set_search
        when /\s+Map hits for path \d+\s+\(1\):/
          res.set_maps
        when /.*gene_maps\s+\S+:(\d+)..(\d+)\s+(\d+)/	
          if res.maps then	
            res.gene_start = "#$1"
            res.gene_end = "#$2"
            res.gene_id = "#$3"
            res.set_maps
          end	
        end

      end
      res
    end

    # The method is called from 'parse_line', to save the sequence alignment information from the gmap output 

    def get_aln(res,l)

      if l =~/.*\w+.*:\d+\s[A|T|C|G].+/ then
        res.aln << l+"\n"
        res.set_save
      end

      if res.c >= 1 and res.c < 3 then
        res.aln << l+"\n"
      end

      if res.c == 3 then
        res.aln.chomp!
        res.set_search
        res.set_save
      end
      if res.set_search then
        res.count
      end
      res
    end


  end

  # This class store the informations of a single Gmap result

  class Result 

  	attr_accessor :name, :chr, :q_start, :q_end, :start, :end, :strand ,:exons, :coverage, :perc_identity, :indels, :mismatch, :aa_change, :gene_start, :gene_end, :gene_id, :aln
    attr_reader :search_aln, :c, :save_aln, :path, :maps
    
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
  		@q_start = nil
  		@q_end = nil 
  		@aln = ""
  		
  	# Inizalize control attributes
  		  		 		
  		@path = false
  		@maps = false
  		@search_aln = false
  		@c = 0
  		@save_aln = false
  	end
  	
  	def set_search
  	  if @search_aln then
  	    @search_aln = false
  	  else
  	    @search_aln = true
  	  end  
	  end
	  
	  def count
      @c += 1
    end
    
    def set_save
      if @save_aln then
        @save_aln = false
      else
        @save_aln = true
      end  
    end
    
    def set_maps
      if @maps then
        @maps = false
      else
        @maps = true
      end
    end

  protected

    attr_writer :search_aln, :c, :save_aln, :path, :maps

  end


end





