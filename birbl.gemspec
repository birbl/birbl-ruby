Gem::Specification.new do |s|
  s.name        = 'birbl'
  s.version     = '0.0.75'
  s.date        = '2013-06-05'
  s.summary     = "A Ruby implementation of the Birbl API"
  s.description = "Use the Birbl API from your own Ruby program"
  s.authors     = ["Aaron Craig"]
  s.email       = 'aaron@birbl.com'
  s.files       = ["lib/birbl.rb"] + Dir["lib/birbl/*"]
  s.homepage    =
    'http://rubygems.org/gems/birbl'

  s.add_runtime_dependency 'rest-client'
  s.add_runtime_dependency 'activemodel'

  s.add_development_dependency 'pry-plus'
  s.add_development_dependency 'rspec'
end
