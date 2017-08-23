Gem::Specification.new do |s|
  s.name        = "toxtree"
  s.version     = "0.0.1"
  s.authors     = ["Christoph Helma"]
  s.email       = ["helma@in-silico.ch"]
  s.homepage    = "http://github.com/opentox/toxtree"
  s.summary     = %q{Toxtree Ruby wrapper}
  s.description = %q{http://toxtree.sourceforge.net}
  s.license     = 'GPL-3.0'

  s.rubyforge_project = "toxtree"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
