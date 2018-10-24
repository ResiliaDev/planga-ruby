Gem::Specification.new do |s|
  s.name         = 'planga'
  s.version      = '0.7.0'
  s.date         = '2018-10-09'
  s.summary      = "Ruby Wrapper for the Planga Chat Service"
  s.description  = "Ruby Wrapper for interacting with the Planga Chat Service."
  s.authors      = ["Wiebe Marten Wijnja", "Jeroen Hoekstra"]
  s.files        = Dir['README.md', 'VERSION', 'Gemfile', 'Rakefile', '{bin,lib,config,vendor}/**/*']
  s.require_path = 'lib'
  s.homepage     = 'https://github.com/ResiliaDev/planga-ruby'
  s.email      = 'contact@planga.io'
  s.license      = 'MIT'

  s.add_dependency('jose', '~> 1.1')
end
