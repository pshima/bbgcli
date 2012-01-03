# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bbgcli"

Gem::Specification.new do |s|
  s.name        = "bbgcli"
  s.version     = Bbgcli::VERSION
  s.authors     = ["Pete Shima"]
  s.email       = ["pete@kingofweb.com"]
  s.homepage    = "https://github.com/petey5king/bbgcli"
  s.summary     = %q{An interactive cli for the blue box api}
  s.description = %q{An interactive cli for the blue box api in ruby}

  s.rubyforge_project = "bbgcli"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "trollop"
  s.add_dependency "httparty"
  s.add_dependency "highline"
  s.add_dependency "net-ssh"

end
