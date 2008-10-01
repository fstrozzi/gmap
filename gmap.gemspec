SPEC = Gem::Specification.new do |s| 
s.name = "Gmap" 
s.version = "1.0.0" 
s.author = "Francesco Strozzi" 
s.email = "francesco.strozzi@gmail.com" 
s.homepage = "http://github.com/fstrozzi/gmap"
s.platform = Gem::Platform::RUBY 
s.summary = "Ruby Class to manage Gmap output" 
candidates = ["doc/files", "doc/files/lib", "doc/files/lib/gmap", "doc/files/lib/gmap/core_rb.html", "doc/files/lib/gmap_rb.html", "doc/files/test", "doc/files/test/unit", "doc/files/test/unit/gmap_test_rb.html", "doc/index.html", "doc/rdoc-style.css", "doc/fr_method_index.html", "doc/fr_class_index.html", "doc/fr_file_index.html", "doc/created.rid", "doc/classes", "doc/classes/Gmap", "doc/classes/Gmap/Core.src", "doc/classes/Gmap/Core.src/M000008.html", "doc/classes/Gmap/Core.src/M000009.html", "doc/classes/Gmap/Core.src/M000006.html", "doc/classes/Gmap/Core.src/M000007.html", "doc/classes/Gmap/Result.html", "doc/classes/Gmap/Core.html", "doc/classes/Gmap/Result.src", "doc/classes/Gmap/Result.src/M000010.html", "doc/classes/Gmap/Result.src/M000011.html", "doc/classes/Gmap/Result.src/M000012.html", "doc/classes/Gmap/Result.src/M000013.html", "doc/classes/Gmap/Result.src/M000014.html", "doc/classes/Gmap.html", "doc/classes/GmapTest.src", "doc/classes/GmapTest.src/M000001.html", "doc/classes/GmapTest.src/M000002.html", "doc/classes/GmapTest.src/M000003.html", "doc/classes/GmapTest.src/M000004.html", "doc/classes/GmapTest.src/M000005.html", "doc/classes/GmapTest.html", "samples/test.gmap", "lib/gmap", "lib/gmap/core.rb", "lib/gmap.rb"] 

s.files = candidates.delete_if do |item| 
	item.include?("git") || item.include?("rdoc") 
end 
s.require_path = "lib" 
s.test_file = "test/unit/gmap_test.rb" 
s.has_rdoc = true
s.extra_rdoc_files = ["README"] 
end
