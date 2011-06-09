$:.push File.expand_path("../lib", __FILE__)
require "sockets/version"

Gem::Specification.new do |s|
  s.name        = "sockets"
  s.version     = Sockets::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Samuel Kadolph"]
  s.email       = ["samuel@kadolph.com"]
  s.homepage    = "https://github.com/samuelkadolph/ruby-sockets"
  s.summary     = %q{}
  s.description = %q{}

  s.files       = Dir["{bin,lib}/**/*"] + ["LICENSE", "README.md"]
  s.executables = ["pruby", "pirb"]
end
