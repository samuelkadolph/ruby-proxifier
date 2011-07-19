$:.push File.expand_path("../lib", __FILE__)
require "proxifier/version"

Gem::Specification.new do |s|
  s.name        = "proxifier"
  s.version     = Proxifier::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Samuel Kadolph"]
  s.email       = ["samuel@kadolph.com"]
  s.homepage    = "https://github.com/samuelkadolph/ruby-proxifier"
  s.summary     = %q{}
  s.description = %q{}

  s.files       = Dir["bin/*", "lib/**/*"] + ["LICENSE", "README.md"]
  s.executables = ["pirb", "pruby"]
end
