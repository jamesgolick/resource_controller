Gem::Specification.new do |s|
  s.name         = "resource_controller"
  s.version      = "0.4.9"
  s.date         = "2008-06-25"
  s.summary      = "Rails RESTful controller abstraction plugin."
  s.email        = "james@giraffesoft.ca"
  s.homepage     = "http://jamesgolick.com/resource_controller"
  s.description  = "resource_controller makes RESTful controllers easier, more maintainable, and super readable.  With the RESTful controller pattern hidden away, you can focus on what makes your controller special."
  s.has_rdoc     = true
  s.authors      = ["James Golick"]
  s.files        = %w(LICENSE README Rakefile init.rb) + Dir.glob("{lib,test}/**/*")
  s.rdoc_options = ["--main", "README"]
end
