SPEC = Gem::Specification.new do |s| 
s.name = "Gmap" 
s.version = "1.0.0" 
s.author = "Francesco Strozzi" 
s.email = "francesco.strozzi@gmail.com" 
s.homepage = "http://github.com/fstrozzi/gmap"
s.platform = Gem::Platform::RUBY 
s.summary = "Ruby Class to manage Gmap output" 
candidates = ['doc/**/*','samples/**/*','lib/**/*','tests/**/*'] 
s.files = candidates.delete_if do |item| 
	item.include?("git") || item.include?("rdoc") 
end 
s.require_path = "lib" 
s.test_file = "test/unit/gmap_test.rb" 
s.has_rdoc = true
s.extra_rdoc_files = ["README"] 
end
