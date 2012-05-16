$:.unshift File.expand_path("../lib", __FILE__)

require "mamechiwa/version"

Gem::Specification.new do |s|
  s.name        = "mamechiwa"
  s.version     = Mamechiwa::Version::STRING
  s.summary     = "hanako kawaii"
  s.description = "Seriarizer to store databae via active record. murina mono ha muri!"
  s.authors     = ["sutetotanuki"]
  s.email       = "sutetotanuki@gmail.com"
  s.files       = Dir["lib/**/*"]
  s.homepage    = "https://github.com/sutetotanuki/mamechiwa"

  s.add_runtime_dependency("activerecord")
  s.add_runtime_dependency("mysql2")
  s.add_development_dependency("rspec")
  s.add_development_dependency("mocha")
  s.add_development_dependency("database_cleaner")
end
